import 'package:crowdleague/utils/locator.dart';
import 'package:flutter/material.dart' hide Notification;

import '../services/user_service.dart';
import 'models/notifications.dart';
import 'widgets/crew_accepted_notification_widget.dart';
import 'widgets/crew_request_notification_widget.dart';
import 'widgets/split_crews_notification_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<List<Notification>>(
          stream: locate<UserService>().notificationsStream(),
          builder: (context, notificationsSnapshot) {
            if (notificationsSnapshot.hasData) {
              final notifications = notificationsSnapshot.data!;
              return ListView.builder(
                itemExtentBuilder: (index, dimensions) {
                  if (index > notifications.length) return null;
                  final Notification notification = notifications[index];
                  if (notification is CrewRequestNotification) {
                    return 120;
                  } else if (notification is CrewAcceptedNotification) {
                    return 90;
                  } else if (notification is SplitCrewsNotification) {
                    return 90;
                  }
                  return 0;
                },
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final Notification notification = notifications[index];
                  if (!notification.viewed) {
                    locate<UserService>()
                        .updateNotification(notification.id, viewed: true);
                  }
                  // TODO: use a pattern here
                  if (notification is CrewRequestNotification) {
                    return CrewRequestNotificationWidget(notification);
                  } else if (notification is CrewAcceptedNotification) {
                    return CrewAcceptedNotificationWidget(notification);
                  } else if (notification is SplitCrewsNotification) {
                    return SplitCrewsNotificationWidget(notification);
                  } else {
                    return Container();
                  }
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
