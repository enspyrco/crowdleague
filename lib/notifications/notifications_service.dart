import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:crowdleague/utils/cache/player_cache.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/notification.dart';
import 'models/views/notification_view_model.dart';

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
  // ignore: unused_field - will be used when new notification types are added
  final PlayerCache _playerCache;

  final _numNotificationsViewedStreamController =
      StreamController<int>.broadcast();
  Stream<int> get numNotificationsViewedStream =>
      _numNotificationsViewedStreamController.stream;

  Future<List<NotificationViewModel>> retrieveNotifications() async {
    final querySnapshot = await _firestore
        .collection('notifications')
        .where('playerId', isEqualTo: _auth.currentUser!.uid)
        .orderBy('timestamp', descending: true)
        .get();

    List<NotificationViewModel> viewModels = [];
    for (final docSnapshot in querySnapshot.docs) {
      try {
        final notification =
            Notification.fromJsonWithId(docSnapshot.id, docSnapshot.data());
        viewModels.add(await _convertToViewModel(notification));
      } catch (e) {
        // Skip notifications with unknown types or parsing errors
        debugPrint('Error parsing notification ${docSnapshot.id}: $e');
      }
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
      for (final docSnapshot in querySnapshot.docs) {
        try {
          final notification =
              Notification.fromJsonWithId(docSnapshot.id, docSnapshot.data());
          viewModels.add(await _convertToViewModel(notification));
        } catch (e) {
          // Skip notifications with unknown types or parsing errors
          debugPrint('Error parsing notification ${docSnapshot.id}: $e');
        }
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
          .where('playerId', isEqualTo: _auth.currentUser!.uid)
          .where('viewed', isEqualTo: false)
          .count()
          .get();

      int numViewed = aggregateQuery.count ?? 0;

      _numNotificationsViewedStreamController.add(numViewed);
    }
  }

  void readAndEmitNotificationsViewed() async {
    if (_auth.currentUser == null) return;
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
    if (notification is UnknownNotification) {
      return UnknownNotificationViewModel(
        notification: notification,
        type: notification.type,
      );
    }

    if (notification is TeamInviteNotification) {
      final inviter = await _playerCache.retrievePlayer(notification.inviterId);
      return TeamInviteNotificationViewModel(
        notification: notification,
        inviterName: inviter.name,
      );
    }

    if (notification is TeamInviteAcceptedNotification) {
      final invitee = await _playerCache.retrievePlayer(notification.inviteeId);
      return TeamInviteAcceptedNotificationViewModel(
        notification: notification,
        inviteeName: invitee.name,
      );
    }

    if (notification is TeamRemovedNotification) {
      return TeamRemovedNotificationViewModel(
        notification: notification,
      );
    }

    if (notification is TeamCaptaincyReceivedNotification) {
      final previousCaptain =
          await _playerCache.retrievePlayer(notification.previousCaptainId);
      return TeamCaptaincyReceivedNotificationViewModel(
        notification: notification,
        previousCaptainName: previousCaptain.name,
      );
    }

    // Fallback for any unhandled types
    return UnknownNotificationViewModel(
      notification: notification as UnknownNotification,
      type: 'unknown',
    );
  }
}
