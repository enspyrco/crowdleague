import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> updateDoc({
    required String path,
    required Map<String, Object?> data,
  }) {
    return _db.doc(path).update(data);
  }

  Future<void> setDoc({
    required String path,
    required Map<String, Object?> data,
  }) {
    return _db.doc(path).set(data);
  }

  Stream<Map<String, Object?>?> documentStream({required String path}) {
    return _db.doc(path).snapshots().map<Map<String, Object?>?>((ref) {
      return ref.data();
    });
  }
}
