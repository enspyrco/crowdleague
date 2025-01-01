import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';

import '../players/models/player.dart';
import 'firestore_service.dart';
import 'storage_service.dart';

class PlayersService {
  PlayersService(
      {required FirestoreService firestoreService,
      required StorageService storageService,
      FirebaseFunctions? cloudFunctions})
      : _firestoreService = firestoreService,
        _storageService = storageService;

  final FirestoreService _firestoreService;
  final StorageService _storageService;

  Future<Set<Player>> getPlayers() async {
    final json = await _firestoreService.getDocs(inCollectionPath: 'profiles');
    return json.map<Player>((element) {
      return Player.fromJson(element);
    }).toSet();
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
}
