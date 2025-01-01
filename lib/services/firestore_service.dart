import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// A service that wraps the FirebaseFirestore.instance meaning tests can
/// provide a test double in place of the service.
///
/// The default Firestore is in Australia.
class FirestoreService {
  FirestoreService(FirebaseApp firebaseApp) {
    (kReleaseMode)
        ? _db = FirebaseFirestore.instanceFor(
            app: firebaseApp, databaseId: '(default)')
        : _db = FirebaseFirestore.instanceFor(
            app: firebaseApp, databaseId: 'firestore-usa');
  }

  late final FirebaseFirestore _db;

  /// Returns the id of the created document.
  Future<String> addDoc({
    required String collectionPath,
    required Map<String, Object?> data,
  }) async {
    final ref = await _db.collection(collectionPath).add(data);
    return ref.id;
  }

  Future<void> addItemsToList({
    required String docPath,
    required String listName,
    required List<Object> items,
  }) {
    return _db.doc(docPath).update({listName: FieldValue.arrayUnion(items)});
  }

  Future<void> removeItemsFromList({
    required String docPath,
    required String listName,
    required List<Object> items,
  }) {
    return _db.doc(docPath).update({listName: FieldValue.arrayRemove(items)});
  }

  Future<void> deleteDoc({required String atPath}) {
    return _db.doc(atPath).delete();
  }

  Stream<Map<String, Object?>?> documentStream({required String path}) {
    return _db.doc(path).snapshots().map<Map<String, Object?>?>((ref) {
      return ref.data();
    });
  }

  Stream<List<Map<String, Object?>?>> collectionStream({required String path}) {
    return _db
        .collection(path)
        .snapshots()
        .map<List<Map<String, Object?>?>>((snapshot) {
      return snapshot.docs.map<Map<String, Object?>?>((snapshot) {
        final json = snapshot.data();
        json['id'] = snapshot.id;
        return json;
      }).toList();
    });
  }

  Future<Map<String, Object?>?> getDoc({
    required String atPath,
  }) async {
    final reference = await _db.doc(atPath).get();
    final json = reference.data();
    json?['id'] = reference.id;
    return json;
  }

  Future<Set<Map<String, Object?>>> getDocs({
    required String inCollectionPath,
  }) async {
    final docsSnapshot = await _db.collection(inCollectionPath).get();
    return docsSnapshot.docs.map<Map<String, Object?>>((snapshot) {
      final json = snapshot.data();
      json['id'] = snapshot.id;
      return json;
    }).toSet();
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

  Future<void> updateDoc({
    required String path,
    required Map<String, Object?> data,
  }) {
    return _db.doc(path).update(data);
  }
}
