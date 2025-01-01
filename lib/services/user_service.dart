import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:rxdart/subjects.dart';

import '../auth/enums/auth_provider.dart';
import '../notifications/models/notification.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
import 'storage_service.dart';

/// The UserService has app scope and a BehaviourSubject seeded with an
/// empty map. The service exposes the BehaviourSubject's stream, listens
/// to firestore's snapshots stream and adds events to the BehaviourSubject.
///
/// The firestore's snapshots stream only emits once then on any updates.
/// The BehaviourSubject at any time and get latest profile data without
/// performing unnecessary reads.
class UserService {
  UserService({
    required AuthService authService,
    required FirestoreService firestoreService,
    required StorageService storageService,
    FirebaseFunctions? cloudFunctions,
  })  : _authService = authService,
        _firestoreService = firestoreService,
        _storageService = storageService,
        _cloudFunctions = (cloudFunctions == null)
            ? FirebaseFunctions.instance
            : cloudFunctions {
    // When a User object is emitted by the FirebaseAuth's onAuthStateChanges
    // stream we create a subscription to the firestore, which is cancelled on
    // sign out to avoid listening to the firestore while signed out.
    _authService.authStateChanges().listen((user) {
      if (user != null) {
        if (profileStreamSubscription != null) {
          profileStreamSubscription!.cancel();
        }

        profileStreamSubscription = _firestoreService
            .documentStream(
          path: 'profiles/${user.uid}',
        )
            .listen((profile) {
          if (profile != null) {
            _userSubject.add(profile);
          }
        });
      }
    });
  }

  late final AuthService _authService;
  late final FirestoreService _firestoreService;
  late final StorageService _storageService;
  final FirebaseFunctions _cloudFunctions;

  final _userSubject = BehaviorSubject<Map<String, Object?>>.seeded({});
  StreamSubscription<Map<String, Object?>?>? profileStreamSubscription;

  Stream<Map<String, Object?>?> get profileDocStream => _userSubject.stream;

  String? get currentUserId {
    return _authService.currentUserId;
  }

  Future<bool> get userHasOnboarded async {
    final profile = await _firestoreService.getDoc(
        atPath: 'fcmTokens/${_authService.currentUserId!}');
    return profile != null;
  }

  Future<void> signInWith({required AuthProvider provider}) async {
    switch (provider) {
      case AuthProvider.apple:
        await _authService.signInWithApple();
      case AuthProvider.google:
        await _authService.signInWithGoogle();
    }
  }

  Future<void> updateProfileName(String name) {
    return _firestoreService.setDoc(
      merge: true,
      path: 'profiles/${_authService.currentUserId!}',
      data: {'name': name},
    );
  }

  Future<void> saveLargeProfilePic(String filePath) async {
    final storagePath = 'profilePics/${currentUserId!}_large';
    // we use an indeterminate progress indicator as the file is so small
    // that the indicator is useless
    await for (final _ in _storageService.uploadFile(
      localPath: filePath,
      storagePath: storagePath,
    )) {}
  }

  Future<void> saveSmallProfilePic(String filePath, int smallSize) async {
    final storagePathSmall = 'profilePics/${currentUserId!}_small';

    await for (final _ in _storageService.uploadFile(
      localPath: '${filePath}_$smallSize',
      storagePath: storagePathSmall,
    )) {}
  }

  Future<Uint8List?> retrieveSmallProfilePic() {
    final storagePathSmall = 'profilePics/${currentUserId!}_small';
    return _storageService.downloadBytes(storagePathSmall);
  }

  Future<Uint8List?> retrieveLargeProfilePic() {
    final storagePathSmall = 'profilePics/${currentUserId!}_large';
    return _storageService.downloadBytes(storagePathSmall);
  }

  Future<List<Notification>> retrieveNotifications() async {
    final notificationJson =
        await _firestoreService.getDocs(inCollectionPath: 'notifications');

    return notificationJson.map<Notification>((json) {
      return Notification.fromJson(json);
    }).toList();
  }

  Future<void> requestFollow(
      {required String requesteeId, required String requesterId}) async {
    await _cloudFunctions
        .httpsCallable('followRequest')
        .call({'requesterId': requesterId, 'requesteeId': requesteeId});
  }

  Future<void> followBack({
    required String requesteeId,
    required String requesterId,
    required String notificationId,
  }) async {
    await _cloudFunctions.httpsCallable('followBack').call({
      'requesterId': requesterId,
      'requesteeId': requesteeId,
      'notificationId': notificationId,
    });
  }

  Future<void> acceptFollowRequest({
    required String requesterId,
    required String requesteeId,
    required String notificationId,
  }) async {
    await _cloudFunctions.httpsCallable('acceptFollowRequest').call({
      'requesterId': requesterId,
      'requesteeId': requesteeId,
      'notificationId': notificationId,
    });
  }

  Future<void> declineFollowRequest(
      String notificationId, String requesterId) async {
    await _firestoreService.deleteDoc(
      atPath:
          'profiles/${_authService.currentUserId}/notifications/$notificationId',
    );

    await _firestoreService.removeItemsFromList(
      docPath: 'profiles/${_authService.currentUserId}',
      listName: 'pendingFollowRequests',
      items: [requesterId],
    );
  }

  Future<void> signOut() async {
    await profileStreamSubscription?.cancel();
    return _authService.signOut();
  }
}
