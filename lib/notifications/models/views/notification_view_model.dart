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
    required this.requesterName,
    required this.requesteeId,
    required this.requesterId,
  });

  final bool waiting;
  final String requesterName;
  final String requesterId;
  final String requesteeId;
}

class CrewAcceptedNotificationViewModel extends NotificationViewModel {
  const CrewAcceptedNotificationViewModel({
    required super.notification,
    required this.playerId,
    required this.otherName,
    required this.otherPlayerId,
  });

  final String playerId;
  final String otherName;
  final String otherPlayerId;
}

class SplitCrewsNotificationViewModel extends NotificationViewModel {
  const SplitCrewsNotificationViewModel({
    required super.notification,
    required this.playerName,
    required this.playerId,
  });

  final String playerName;
  final String playerId;
}
