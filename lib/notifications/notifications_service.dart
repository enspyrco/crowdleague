import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/utils/cache/player_cache.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/notification.dart';
import 'models/views/notification_view_model.dart';
import '../players/models/player.dart';

class NotificationsService {
  NotificationsService({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required PlayerCache playerCache,
  })  : _auth = auth,
        _firestore = firestore,
        _playerCache = playerCache;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final PlayerCache _playerCache;

  final _numNotificationsViewedStreamController = StreamController<int>();
  Stream<int> get numNotificationsViewedStream =>
      _numNotificationsViewedStreamController.stream;

  Future<List<NotificationViewModel>> retrieveNotifications() async {
    final querySnapshot = await _firestore
        .collection('notifications')
        .where('playerId', isEqualTo: _auth.currentUser!.uid)
        .orderBy('timestamp', descending: true)
        .get();

    List<NotificationViewModel> viewModels = [];
    for (final docSnaphot in querySnapshot.docs) {
      final notification =
          Notification.fromJsonWithId(docSnaphot.id, docSnaphot.data());
      viewModels.add(await _convertToViewModel(notification));
    }

    return viewModels;
  }

  Stream<List<NotificationViewModel>> notificationsStream() {
    return _firestore
        .collection('notifications')
        .where('playerId', isEqualTo: _auth.currentUser!.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap<List<NotificationViewModel>>((querySnapshot) async {
      List<NotificationViewModel> viewModels = [];
      for (final docSnaphot in querySnapshot.docs) {
        final notification =
            Notification.fromJsonWithId(docSnaphot.id, docSnaphot.data());
        viewModels.add(await _convertToViewModel(notification));
      }

      return viewModels;
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

  Future<NotificationViewModel> _convertToViewModel(
      Notification notification) async {
    if (notification is CrewAcceptedNotification) {
      final String otherPlayerId =
          notification.requesterId == _auth.currentUser!.uid
              ? notification.requesteeId
              : notification.requesterId;

      final Player otherPlayer =
          await _playerCache.retrievePlayer(otherPlayerId);

      return CrewAcceptedNotificationViewModel(
        notification: notification,
        playerId: notification.requesterId,
        otherName: otherPlayer.name,
        otherPlayerId: otherPlayer.id,
      );
    }

    if (notification is CrewRequestNotification) {
      final Player requester =
          await _playerCache.retrievePlayer(notification.requesterId);

      return CrewRequestNotificationViewModel(
        notification: notification,
        requesterName: requester.name,
        requesteeId: notification.requesteeId,
        requesterId: notification.requesterId,
        waiting: notification.waiting,
      );
    }

    if (notification is SplitCrewsNotification) {
      final Player player =
          await _playerCache.retrievePlayer(notification.requesteeId);

      return SplitCrewsNotificationViewModel(
        notification: notification,
        playerName: player.name,
        playerId: player.id,
      );
    }

    throw 'No view model for notification type: ${notification.runtimeType}';
  }
}
