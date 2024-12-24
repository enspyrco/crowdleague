import 'dart:typed_data';

import 'firestore_service.dart';
import 'storage_service.dart';

class PlayersService {
  PlayersService(
      {required FirestoreService firestoreService,
      required StorageService storageService})
      : _firestoreService = firestoreService,
        _storageService = storageService;

  final FirestoreService _firestoreService;
  final StorageService _storageService;

  Future<Set<Map<String, Object?>>> getPlayers() {
    return _firestoreService.getDocs(inCollectionPath: 'profiles');
  }

  Future<Map<String, Object?>?> getPlayer(String playerId) {
    return _firestoreService.getDoc(atPath: 'profiles/$playerId');
  }

  Future<Uint8List?> retrieveSmallProfilePic(String playerId) {
    return _storageService.downloadBytes('profilePics/${playerId}_small');
  }

  Future<Uint8List?> retrieveLargeProfilePic(String playerId) {
    return _storageService.downloadBytes('profilePics/${playerId}_large');
  }
}
