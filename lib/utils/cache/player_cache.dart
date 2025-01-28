// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../players/models/player.dart';

class PlayerCache {
  PlayerCache({
    required FirebaseFirestore firestore,
    int staleSeconds = 15,
  })  : _firestore = firestore,
        _staleSeconds = staleSeconds;

  final FirebaseFirestore _firestore;
  final int _staleSeconds;

  final Map<String, PlayerCacheItem> _cache = {};

  Future<Player> retrievePlayer(String playerId) async {
    PlayerCacheItem? item = _cache[playerId];

    if (item == null ||
        DateTime.now().difference(item.timestamp).inSeconds > _staleSeconds) {
      final reference =
          await _firestore.collection('profiles').doc(playerId).get();
      _cache[playerId] = PlayerCacheItem(
          player: Player.fromJsonWithId(reference.id, reference.data() ?? {}),
          timestamp: DateTime.now());
    }
    return _cache[playerId]!.player;
  }
}

class PlayerCacheItem {
  PlayerCacheItem({
    required this.player,
    required this.timestamp,
  });

  Player player;
  DateTime timestamp;
}
