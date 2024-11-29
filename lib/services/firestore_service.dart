import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

/// A service that wraps the FirebaseFirestore.instance meaning tests can
/// provide a test double in place of the service.
class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> updateDoc({
    required String path,
    required Map<String, Object?> data,
  }) {
    return _db.doc(path).update(data);
  }

  /// Uses the cloud_firestore's set document - when marge is true, this becomes
  /// an update where a new document will be created if none exists.
  Future<void> setDoc({
    required String path,
    required Map<String, Object?> data,
    bool merge = false,
  }) {
    return _db.doc(path).set(data, SetOptions(merge: merge));
  }

  Stream<Map<String, Object?>?> documentStream({required String path}) {
    return _db.doc(path).snapshots().map<Map<String, Object?>?>((ref) {
      return ref.data();
    });
  }
}
