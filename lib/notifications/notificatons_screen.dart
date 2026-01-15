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
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<NotificationViewModel>>(
          stream: locate<NotificationsService>().notificationsStream(),
          builder: (context, viewModelsSnapshot) {
            if (viewModelsSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModelsSnapshot.hasError) {
              return const Center(
                child: Text('Error loading notifications'),
              );
            }

            if (viewModelsSnapshot.hasData) {
              final viewModels = viewModelsSnapshot.data!;

              if (viewModels.isEmpty) {
                return const Center(
                  child: Text('No notifications yet'),
                );
              }

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
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
