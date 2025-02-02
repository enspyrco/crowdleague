import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/players/enums/pic_size.dart';
import 'package:crowdleague/utils/cache/image_bytes_cache.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'models/player.dart';
import '../utils/cache/player_cache.dart';

class PlayersService {
  PlayersService({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required PlayerCache playerCache,
    required ImageBytesCache imageBytesCache,
  })  : _firestore = firestore,
        _playerCache = playerCache,
        _imageBytesCache = imageBytesCache;

  final FirebaseFirestore _firestore;
  final PlayerCache _playerCache;
  final ImageBytesCache _imageBytesCache;

  Future<List<Player>> retrievePlayers() async {
    final docsSnapshot = await _firestore.collection('profiles').get();
    return docsSnapshot.docs.map<Player>((snapshot) {
      final json = snapshot.data();
      json['id'] = snapshot.id;
      return Player.fromJson(json);
    }).toList();
  }

  Future<Player?> retrievePlayer(String playerId) {
    return _playerCache.retrievePlayer(playerId);
  }

  Stream<Player?> listenToPlayer(String playerId) {
    return _firestore
        .collection('profiles')
        .doc(playerId)
        .snapshots()
        .map<Player?>((snapshot) {
      if (snapshot.data() == null) return null;
      final json = Map<String, Object?>.from(snapshot.data()!);
      json['id'] = snapshot.id;
      return Player.fromJson(json);
    });
  }

  Future<Uint8List?> retrieveProfilePic(
      String playerId, PicSize picSize) async {
    final String picUriString;
    if (picSize == PicSize.small) {
      picUriString = 'profilePics/${playerId}_small';
    } else {
      picUriString = 'profilePics/${playerId}_large';
    }
    return await _imageBytesCache.retrieveImage(picUriString);
  }
}
