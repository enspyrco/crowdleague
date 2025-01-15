import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:shared_preferences/shared_preferences.dart';

import '../notifications/models/notifications.dart';
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

  final _numNotificationsViewedStreamController = StreamController<int>();
  Stream<int> get numNotificationsViewedStream =>
      _numNotificationsViewedStreamController.stream;

  /// Check for a saved FCM token, which is the last part of onboarding.
  Future<bool> get userHasOnboarded async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarded') ?? false;
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
        .orderBy('timestamp', descending: true)
        .get();
    return querySnapshot.docs.map<Notification>((snapshot) {
      final json = snapshot.data();
      json['id'] = snapshot.id;
      return Notification.fromJson(json);
    }).toList();
  }

  Stream<List<Notification>> notificationsStream() {
    return _firestore
        .collection('notifications')
        .where('playerId', isEqualTo: _auth.currentUser!.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map<List<Notification>>((querySnapshot) {
      return querySnapshot.docs.map<Notification>((docSnapshot) {
        final json = docSnapshot.data();
        json['id'] = docSnapshot.id;
        return Notification.fromJson(json);
      }).toList();
    });
  }

  Future<void> updateNotification(String id, {required bool? viewed}) async {
    if (viewed != null) {
      await _firestore
          .collection('notifications')
          .doc(id)
          .update({'viewed': viewed});

      final aggregateQuery = await _firestore
          .collection('notifications')
          .where('viewed', isEqualTo: false)
          .count()
          .get();

      int numViewed = aggregateQuery.count ?? 0;

      _numNotificationsViewedStreamController.add(numViewed);
    }
  }

  void readAndEmitNotificationsViewed() async {
    final aggregateQuery = await _firestore
        .collection('notifications')
        .where('playerId', isEqualTo: _auth.currentUser!.uid)
        .where('viewed', isEqualTo: false)
        .count()
        .get();

    _numNotificationsViewedStreamController.add(aggregateQuery.count ?? 0);
  }

  Future<void> requestCrew({required String playerId}) async {
    await _cloudFunctions.httpsCallable('crewRequest').call({
      'requesterId': _auth.currentUser!.uid,
      'requesteeId': playerId,
      'dbName': dbName,
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
      'dbName': dbName,
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
      'dbName': dbName,
    });
  }
}
