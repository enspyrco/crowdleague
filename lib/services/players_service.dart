import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/players/enums/pic_size.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../players/models/player.dart';

class PlayersService {
  PlayersService({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required Map<String, Player> playerCache,
    required Map<String, Uint8List> imageCache,
  })  : _firestore = firestore,
        _storage = storage,
        _playerCache = playerCache,
        _imageCache = imageCache;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final Map<String, Player> _playerCache;
  final Map<String, Uint8List> _imageCache;

  Future<List<Player>> getPlayers() async {
    final docsSnapshot = await _firestore.collection('profiles').get();
    return docsSnapshot.docs.map<Player>((snapshot) {
      final json = snapshot.data();
      json['id'] = snapshot.id;
      return Player.fromJson(json);
    }).toList();
  }

  Future<Player?> getPlayer(String playerId) async {
    if (!_playerCache.containsKey(playerId)) {
      final reference =
          await _firestore.collection('profiles').doc(playerId).get();
      final json = reference.data();
      if (json == null) return null;
      json['id'] = reference.id;
      _playerCache[playerId] = Player.fromJson(json);
    }
    return Future.value(_playerCache[playerId]);
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
    if (!_imageCache.containsKey(picUriString)) {
      _imageCache[picUriString] =
          await _storage.ref(picUriString).getData() ?? Uint8List(0);
    }
    return Future.value(_imageCache[picUriString]);
  }
}
