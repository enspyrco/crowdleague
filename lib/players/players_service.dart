import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'models/player.dart';
import '../utils/cache/player_cache.dart';

class PlayersService {
  PlayersService({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required PlayerCache playerCache,
  })  : _firestore = firestore,
        _playerCache = playerCache;

  final FirebaseFirestore _firestore;
  final PlayerCache _playerCache;

  Future<List<Player>> retrievePlayers() async {
    final docsSnapshot = await _firestore.collection('profiles').get();
    return docsSnapshot.docs.map<Player>((snapshot) {
      return Player.fromJsonWithId(snapshot.id, snapshot.data());
    }).toList();
  }

  Future<Player?> retrievePlayer(String playerId) {
    return _playerCache.retrievePlayer(playerId);
  }

  PlayerCacheItem? bustCache(String playerId) {
    return _playerCache.bustPlayer(playerId);
  }

  Stream<Player?> listenToPlayer(String playerId) {
    return _firestore
        .collection('profiles')
        .doc(playerId)
        .snapshots()
        .map<Player?>((snapshot) {
      if (snapshot.data() == null) return null;
      return Player.fromJsonWithId(snapshot.id, snapshot.data()!);
    });
  }
}
