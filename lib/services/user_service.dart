import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/globals.dart';

class UserService {
  UserService({
    required FirebaseFunctions cloudFunctions,
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _auth = firebaseAuth,
        _firestore = firestore,
        _cloudFunctions = cloudFunctions;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _cloudFunctions;

  /// Check shared prefs for onboarding status.
  Future<bool> get userHasOnboarded async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarded') ?? false;
  }

  Future<void> updateProfileName(String name) {
    return _firestore
        .doc('profiles/${_auth.currentUser!.uid}')
        .set({'name': name}, SetOptions(merge: true));
  }

  Future<void> updateProfilePic(int picId) {
    return _firestore
        .doc('profiles/${_auth.currentUser!.uid}')
        .set({'picId': picId}, SetOptions(merge: true));
  }

  Future<void> requestCrew({required String playerId}) async {
    await _cloudFunctions.httpsCallable('crewRequest').call({
      'requesterId': _auth.currentUser!.uid,
      'requesteeId': playerId,
      'dbName': kDatabaseName,
    });
  }

  Future<void> acceptCrewRequest({
    required String requesterId,
    required String requesteeId,
    required String notificationId,
  }) async {
    await _firestore
        .doc('notifications/$notificationId')
        .set({'waiting': true}, SetOptions(merge: true));

    await _cloudFunctions.httpsCallable('acceptCrewRequest').call({
      'requesterId': requesterId,
      'requesteeId': requesteeId,
      'notificationId': notificationId,
      'dbName': kDatabaseName,
    });
  }

  Future<void> declineCrewRequest(
      String notificationId, String requesterId) async {
    await _firestore.doc('notifications/$notificationId').delete();

    await _firestore.doc('profiles/${_auth.currentUser!.uid}').update({
      'pendingCrewRequests': FieldValue.arrayRemove([requesterId])
    });
  }

  Future<void> splitCrews(String playerId) async {
    await _cloudFunctions.httpsCallable('splitCrews').call({
      'requesterId': _auth.currentUser!.uid,
      'requesteeId': playerId,
      'dbName': kDatabaseName,
    });
  }
}
