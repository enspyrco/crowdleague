import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../players/models/player.dart';

class PlayersService {
  PlayersService({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  })  : _firestore = firestore,
        _storage = storage;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  Future<List<Player>> getPlayers() async {
    final docsSnapshot = await _firestore.collection('profiles').get();
    return docsSnapshot.docs.map<Player>((snapshot) {
      final json = snapshot.data();
      json['id'] = snapshot.id;
      return Player.fromJson(json);
    }).toList();
  }

  Future<Player?> getPlayer(String playerId) async {
    final reference =
        await _firestore.collection('profiles').doc(playerId).get();
    final json = reference.data();
    if (json == null) return null;
    json['id'] = reference.id;
    return Player.fromJson(json);
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

  Future<Uint8List?> retrieveSmallProfilePic(String playerId) {
    return _storage.ref('profilePics/${playerId}_small').getData();
  }

  Future<Uint8List?> retrieveLargeProfilePic(String playerId) {
    return _storage.ref('profilePics/${playerId}_large').getData();
  }
}
