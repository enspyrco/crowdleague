import 'dart:async';

import 'package:crowdleague/services/auth_service.dart';
import 'package:rxdart/subjects.dart';

import '../utils/locator.dart';
import 'firestore_service.dart';

/// The UserService has app scope and a BehaviourSubject seeded with an
/// empty map. The service exposes the BehaviourSubject's stream, listens
/// to firestore's snapshots stream and adds events to the BehaviourSubject.
///
/// The firestore's snapshots stream only emits once then on any updates.
/// The BehaviourSubject at any time and get latest profile data without
/// performing unnecessary reads.
///
/// The AuthService sets up the UserService listening to firestore's
/// snapshots when the user signs in or opens the app already signed in.
/// Snapshots are then added to the BehaviourSubject.
class UserService {
  final _userSubject = BehaviorSubject<Map<String, Object?>>.seeded({});
  StreamSubscription<Map<String, Object?>?>? profileStreamSubscription;

  Stream<Map<String, Object?>?> get profileDocStream => _userSubject.stream;

  /// Called by the AuthService when a User object is emitted by the
  /// FirebaseAuth's onAuthStateChanges stream.
  void listenToProfileStream(String userId) {
    if (profileStreamSubscription != null) {
      profileStreamSubscription!.cancel();
    }

    profileStreamSubscription = locate<FirestoreService>()
        .documentStream(
      path: 'profiles/$userId',
    )
        .listen((profile) {
      if (profile != null) {
        _userSubject.add(profile);
      }
    });
  }

  Future<void> updateProfilePicUrl(String url) async {
    return locate<FirestoreService>().setDoc(
      merge: true,
      path: 'profiles/${locate<AuthService>().currentUserId!}',
      data: {'largePic': url},
    );
  }

  Future<void> updateProfileName(String name) {
    return locate<FirestoreService>().setDoc(
      merge: true,
      path: 'profiles/${locate<AuthService>().currentUserId!}',
      data: {'name': name},
    );
  }
}
