import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/services/firestore_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

class FirestoreServiceTestDouble implements FirestoreService {
  final _db = FakeFirebaseFirestore();

  @override
  Future<String> addDoc({
    required String collectionPath,
    required Map<String, Object?> data,
  }) async {
    final ref = await _db.collection(collectionPath).add(data);
    return ref.id;
  }

  @override
  Future<void> deleteDoc({required String atPath}) {
    return _db.doc(atPath).delete();
  }

  @override
  Stream<Map<String, Object?>?> documentStream({required String path}) {
    return _db.doc(path).snapshots().map<Map<String, Object?>?>((ref) {
      return ref.data();
    });
  }

  @override
  Future<Map<String, Object?>?> getDoc({required String atPath}) async {
    final reference = await _db.doc(atPath).get();
    final json = reference.data();
    json?['id'] = reference.id;
    return json;
  }

  @override
  Future<Set<Map<String, Object?>>> getDocs(
      {required String inCollectionPath}) async {
    final snapshot = await _db.collection(inCollectionPath).get();
    return snapshot.docs.map<Map<String, Object?>>((snapshot) {
      final json = snapshot.data();
      json['id'] = snapshot.id;
      return json;
    }).toSet();
  }

  @override
  Future<void> setDoc(
      {required String path,
      required Map<String, Object?> data,
      bool merge = false}) {
    return _db.doc(path).set(data, SetOptions(merge: merge));
  }

  @override
  Future<void> updateDoc(
      {required String path, required Map<String, Object?> data}) {
    return _db.doc(path).update(data);
  }

  @override
  Future<void> addItemsToList(
      {required String docPath,
      required String listName,
      required List<Object> items}) {
    // TODO: implement addItemsToList
    throw UnimplementedError();
  }

  @override
  Future<void> removeItemsFromList(
      {required String docPath,
      required String listName,
      required List<Object> items}) {
    // TODO: implement removeItemsFromList
    throw UnimplementedError();
  }

  @override
  Stream<List<Map<String, Object?>?>> collectionStream({required String path}) {
    // TODO: implement collectionStream
    throw UnimplementedError();
  }
}
