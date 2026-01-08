import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:crowdleague/players/models/player.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/globals.dart';

/// Unified service for user authentication, profile management, and crew operations.
///
/// Has app scope with a BehaviorSubject seeded with an empty map.
/// Exposes the BehaviorSubject's stream, listens to Firestore's snapshots
/// stream and adds events to the BehaviorSubject.
class UserService {
  UserService({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required FirebaseFunctions cloudFunctions,
  })  : _auth = firebaseAuth,
        _firestore = firestore,
        _cloudFunctions = cloudFunctions {
    // When a User object is emitted by FirebaseAuth's authStateChanges
    // stream we create a subscription to Firestore, which is cancelled on
    // sign out to avoid listening while signed out.
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        if (_profileStreamSubscription != null) {
          _profileStreamSubscription!.cancel();
        }

        _profileStreamSubscription = _firestore
            .doc('profiles/${user.uid}')
            .snapshots()
            .map<Map<String, Object?>?>((ref) => ref.data())
            .listen((profile) {
          if (profile != null) {
            _userSubject.add(profile);
          }
        });
      }
    });
  }

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _cloudFunctions;

  final _userSubject = BehaviorSubject<Map<String, Object?>>.seeded({});
  StreamSubscription<Map<String, Object?>?>? _profileStreamSubscription;

  // ==================== Authentication ====================

  String? get currentUserId => _auth.currentUser?.uid;

  Stream<Map<String, Object?>?> get profileDocStream => _userSubject.stream;

  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      await _auth.signInWithPopup(provider);
    } else {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await GoogleSignIn.instance.initialize(
            clientId:
                '945991608888-q96ftvo7cskp4bd1ka8d8n28v6859243.apps.googleusercontent.com',
            serverClientId:
                '945991608888-2c08mlv2221m36n0rq474ot9885cnesk.apps.googleusercontent.com');
      }

      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential =
          GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      await _auth.signInWithCredential(credential);
    }
  }

  Future<void> signInWithApple() async {
    final provider = AppleAuthProvider();
    await _auth.signInWithProvider(provider);
  }

  Future<void> signOut() async {
    await _profileStreamSubscription?.cancel();
    return _auth.signOut();
  }

  Player? getUserPlayer() {
    if (_auth.currentUser == null) return null;
    return Player.fromJsonWithId(_auth.currentUser!.uid, _userSubject.value);
  }

  // ==================== Profile Management ====================

  Future<bool> get userHasOnboarded async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarded') ?? false;
  }

  Future<void> updateProfileName(String name) {
    return _firestore
        .doc('profiles/${_auth.currentUser!.uid}')
        .set({'name': name}, SetOptions(merge: true));
  }

  // ==================== Crew Operations ====================

  Future<void> requestCrew({required String playerId}) async {
    await _cloudFunctions.httpsCallable('crewRequest').call({
      'requesterId': _auth.currentUser!.uid,
      'requesteeId': playerId,
      'dbName': kDatabaseName,
    });
  }

  Future<void> acceptCrewRequest({
    required String requesterId,
    required String requesteeId,
    required String notificationId,
  }) async {
    await _firestore
        .doc('notifications/$notificationId')
        .set({'waiting': true}, SetOptions(merge: true));

    await _cloudFunctions.httpsCallable('acceptCrewRequest').call({
      'requesterId': requesterId,
      'requesteeId': requesteeId,
      'notificationId': notificationId,
      'dbName': kDatabaseName,
    });
  }

  Future<void> declineCrewRequest(
      String notificationId, String requesterId) async {
    await _firestore.doc('notifications/$notificationId').delete();

    await _firestore.doc('profiles/${_auth.currentUser!.uid}').update({
      'pendingCrewRequests': FieldValue.arrayRemove([requesterId])
    });
  }

  Future<void> splitCrews(String playerId) async {
    await _cloudFunctions.httpsCallable('splitCrews').call({
      'requesterId': _auth.currentUser!.uid,
      'requesteeId': playerId,
      'dbName': kDatabaseName,
    });
  }

  // ==================== Account Management ====================

  /// Permanently deletes the user's account and all associated data.
  /// This includes: profile, notifications, crew memberships, messages,
  /// profile photos, and Firebase Auth account.
  Future<void> deleteAccount() async {
    await _profileStreamSubscription?.cancel();
    await _cloudFunctions.httpsCallable('deleteAccount').call({
      'dbName': kDatabaseName,
    });
  }
}
