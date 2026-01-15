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
