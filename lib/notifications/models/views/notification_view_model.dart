import '../notification.dart';

sealed class NotificationViewModel {
  const NotificationViewModel({
    required this.notification,
  });

  final Notification notification;
}

/// View model for unknown or deprecated notification types
class UnknownNotificationViewModel extends NotificationViewModel {
  const UnknownNotificationViewModel({
    required super.notification,
    required this.type,
  });

  final String type;
}

/// View model for team invite notification
class TeamInviteNotificationViewModel extends NotificationViewModel {
  const TeamInviteNotificationViewModel({
    required TeamInviteNotification super.notification,
    required this.inviterName,
  });

  final String inviterName;

  TeamInviteNotification get teamInvite =>
      notification as TeamInviteNotification;
}

/// View model for team invite accepted notification
class TeamInviteAcceptedNotificationViewModel extends NotificationViewModel {
  const TeamInviteAcceptedNotificationViewModel({
    required TeamInviteAcceptedNotification super.notification,
    required this.inviteeName,
  });

  final String inviteeName;

  TeamInviteAcceptedNotification get teamInviteAccepted =>
      notification as TeamInviteAcceptedNotification;
}

/// View model for team removed notification
class TeamRemovedNotificationViewModel extends NotificationViewModel {
  const TeamRemovedNotificationViewModel({
    required TeamRemovedNotification super.notification,
  });

  TeamRemovedNotification get teamRemoved =>
      notification as TeamRemovedNotification;
}

/// View model for team captaincy received notification
class TeamCaptaincyReceivedNotificationViewModel extends NotificationViewModel {
  const TeamCaptaincyReceivedNotificationViewModel({
    required TeamCaptaincyReceivedNotification super.notification,
    required this.previousCaptainName,
  });

  final String previousCaptainName;

  TeamCaptaincyReceivedNotification get captaincyReceived =>
      notification as TeamCaptaincyReceivedNotification;
}
