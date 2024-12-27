import 'dart:typed_data';

import '../players/models/player.dart';
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

  Future<Player?> getPlayer(String playerId) async {
    final json = await _firestoreService.getDoc(atPath: 'profiles/$playerId');
    if (json == null) return null;
    return Player.fromJson(json);
  }

  Future<Uint8List?> retrieveSmallProfilePic(String playerId) {
    return _storageService.downloadBytes('profilePics/${playerId}_small');
  }

  Future<Uint8List?> retrieveLargeProfilePic(String playerId) {
    return _storageService.downloadBytes('profilePics/${playerId}_large');
  }

  Future<void> requestTeamUp(
      {required String requestee, required String requester}) async {
    return _firestoreService
        .setDoc(path: 'profiles/$requester/team-requests/$requestee', data: {});
  }
}
