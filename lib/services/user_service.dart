import 'dart:async';
import 'dart:typed_data';

import 'package:rxdart/subjects.dart';

import '../auth/enums/auth_provider.dart';
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
///
/// The AuthService sets up the UserService listening to firestore's
/// snapshots when the user signs in or opens the app already signed in.
/// Snapshots are then added to the BehaviourSubject.
class UserService {
  UserService({
    required AuthService authService,
    required FirestoreService firestoreService,
    required StorageService storageService,
  })  : _authService = authService,
        _firestoreService = firestoreService,
        _storageService = storageService {
    _authService.authStateChanges().listen((user) {
      if (user != null) {
        listenToProfileStream(user.uid);
      }
    });
  }

  late final AuthService _authService;
  late final FirestoreService _firestoreService;
  late final StorageService _storageService;

  final _userSubject = BehaviorSubject<Map<String, Object?>>.seeded({});
  StreamSubscription<Map<String, Object?>?>? profileStreamSubscription;

  Stream<Map<String, Object?>?> get profileDocStream => _userSubject.stream;

  String? get currentUserId {
    return _authService.currentUserId;
  }

  /// Called by the AuthService when a User object is emitted by the
  /// FirebaseAuth's onAuthStateChanges stream.
  void listenToProfileStream(String userId) {
    if (profileStreamSubscription != null) {
      profileStreamSubscription!.cancel();
    }

    profileStreamSubscription = _firestoreService
        .documentStream(
      path: 'profiles/$userId',
    )
        .listen((profile) {
      if (profile != null) {
        _userSubject.add(profile);
      }
    });
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

  Future<void> signOut() async {
    await profileStreamSubscription?.cancel();
    return _authService.signOut();
  }
}
