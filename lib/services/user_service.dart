import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

import '../notifications/models/notifications.dart';

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

  /// Check for a saved FCM token, which is the last part of onboarding.
  Future<bool> get userHasOnboarded async {
    final tokenReference =
        await _firestore.doc('fcmTokens/${_auth.currentUser!.uid}').get();
    return tokenReference.data() != null;
  }

  Future<void> updateProfileName(String name) {
    return _firestore
        .doc('profiles/${_auth.currentUser!.uid}')
        .set({'name': name}, SetOptions(merge: true));
  }

  Future<List<Notification>> retrieveNotifications() async {
    final querySnapshot = await _firestore
        .collection('notifications')
        .where('playerId', isEqualTo: _auth.currentUser!.uid)
        .get();
    return querySnapshot.docs.map<Notification>((snapshot) {
      final json = snapshot.data();
      json['id'] = snapshot.id;
      return Notification.fromJson(json);
    }).toList();
  }

  Stream<List<Notification>> listenToNotifications() {
    return _firestore
        .collection('notifications')
        .where('playerId', isEqualTo: _auth.currentUser!.uid)
        .snapshots()
        .map<List<Notification>>((querySnapshot) {
      return querySnapshot.docs.map<Notification>((docSnapshot) {
        final json = docSnapshot.data();
        json['id'] = docSnapshot.id;
        return Notification.fromJson(json);
      }).toList();
    });
  }

  Future<void> requestCrew(
      {required String requesteeId, required String requesterId}) async {
    await _cloudFunctions
        .httpsCallable('crewRequest')
        .call({'requesterId': requesterId, 'requesteeId': requesteeId});
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
    });
  }

  Future<void> declineCrewRequest(
      String notificationId, String requesterId) async {
    await _firestore.doc('notifications/$notificationId').delete();

    await _firestore.doc('profiles/${_auth.currentUser?.uid}').update({
      'pendingCrewRequests': FieldValue.arrayRemove([requesterId])
    });
  }
}
