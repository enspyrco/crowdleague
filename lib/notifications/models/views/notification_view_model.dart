import 'dart:typed_data';

import '../notification.dart';

sealed class NotificationViewModel {
  const NotificationViewModel({
    required this.notification,
  });

  final Notification notification;
}

class CrewRequestNotificationViewModel extends NotificationViewModel {
  const CrewRequestNotificationViewModel({
    required super.notification,
    required this.waiting,
    required this.playerName,
    required this.picBytes,
    required this.requesteeId,
    required this.requesterId,
  });

  final bool waiting;
  final String playerName;
  final Uint8List picBytes;
  final String requesterId;
  final String requesteeId;
}

class CrewAcceptedNotificationViewModel extends NotificationViewModel {
  const CrewAcceptedNotificationViewModel({
    required super.notification,
    required this.playerId,
    required this.otherName,
    required this.otherPicBytes,
  });

  final String playerId;
  final String otherName;
  final Uint8List otherPicBytes;
}

class SplitCrewsNotificationViewModel extends NotificationViewModel {
  const SplitCrewsNotificationViewModel({
    required super.notification,
    required this.playerName,
    required this.playerId,
    required this.playerPicBytes,
  });

  final String playerName;
  final String playerId;
  final Uint8List playerPicBytes;
}
