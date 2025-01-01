import 'package:crowdleague/utils/locator.dart';
import 'package:flutter/material.dart' hide Notification;

import '../services/user_service.dart';
import 'models/notification.dart';
import 'widgets/follow_back_notification_widget.dart';
import 'widgets/follow_request_notification_widget.dart';

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
          stream: locate<UserService>().listenToNotifications(),
          builder: (context, notificatiosnSnapshot) {
            if (notificatiosnSnapshot.hasData) {
              return ListView.builder(
                itemCount: notificatiosnSnapshot.data!.length,
                itemBuilder: (context, index) {
                  final Notification notification =
                      notificatiosnSnapshot.data![index];
                  if (notification is FollowRequestNotification) {
                    return FollowRequestNotificationWidget(
                        notification: notification);
                  } else if (notification is FollowBackNotification) {
                    return FollowBackNotificationWidget(notification);
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
