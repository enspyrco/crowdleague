import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/subjects.dart';

/// The UserAuthService has app scope and a BehaviourSubject seeded with an
/// empty map. The service exposes the BehaviourSubject's stream, listens
/// to firestore's snapshots stream and adds events to the BehaviourSubject.
///
/// The firestore's snapshots stream only emits once then on any updates.
/// The BehaviourSubject can be listened to at any time to get latest profile
/// data without performing unnecessary reads.
class UserAuthService {
  UserAuthService({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _auth = firebaseAuth,
        _firestore = firestore {
    // When a User object is emitted by the FirebaseAuth's onAuthStateChanges
    // stream we create a subscription to the firestore, which is cancelled on
    // sign out to avoid listening to the firestore while signed out.
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        if (profileStreamSubscription != null) {
          profileStreamSubscription!.cancel();
        }

        profileStreamSubscription = _firestore
            .doc('profiles/${user.uid}')
            .snapshots()
            .map<Map<String, Object?>?>((ref) {
          return ref.data();
        }).listen((profile) {
          if (profile != null) {
            _userSubject.add(profile);
          }
        });
      }
    });
  }

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  final _userSubject = BehaviorSubject<Map<String, Object?>>.seeded({});
  StreamSubscription<Map<String, Object?>?>? profileStreamSubscription;

  Stream<Map<String, Object?>?> get profileDocStream => _userSubject.stream;

  String? get currentUserId {
    return _auth.currentUser?.uid;
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final _ = await _auth.signInWithCredential(credential);
  }

  Future<void> signInWithApple() async {
    final provider = AppleAuthProvider();

    final _ = _auth.signInWithProvider(provider);
  }

  Future<void> signOut() async {
    await profileStreamSubscription?.cancel();
    return _auth.signOut();
  }
}
