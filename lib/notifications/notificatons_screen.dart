import 'package:crowdleague/utils/locator.dart';
import 'package:flutter/material.dart' hide Notification;

import 'notifications_service.dart';
import 'models/views/notification_view_model.dart';
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
        child: FutureBuilder(
          future: locate<NotificationsService>().retrieveNotifications(),
          builder: (context, viewModelsSnapshot) {
            if (viewModelsSnapshot.hasData) {
              final viewModels = viewModelsSnapshot.data!;
              return ListView.builder(
                itemCount: viewModels.length,
                itemBuilder: (context, index) {
                  final NotificationViewModel viewModel = viewModels[index];
                  if (!viewModel.notification.viewed) {
                    locate<NotificationsService>().updateNotification(
                        viewModel.notification.id,
                        viewed: true);
                  }

                  if (viewModel is CrewRequestNotificationViewModel) {
                    return CrewRequestNotificationWidget(viewModel);
                  }
                  if (viewModel is CrewAcceptedNotificationViewModel) {
                    return CrewAcceptedNotificationWidget(viewModel);
                  }
                  if (viewModel is SplitCrewsNotificationViewModel) {
                    return SplitCrewsNotificationWidget(viewModel);
                  }

                  return Container();
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
