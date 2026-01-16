import 'package:crowdleague/teams/teams_service.dart';
import 'package:crowdleague/utils/locator.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:go_router/go_router.dart';

import 'notifications_service.dart';
import 'models/views/notification_view_model.dart';

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

                  return _buildNotificationCard(context, viewModel);
                },
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
      BuildContext context, NotificationViewModel viewModel) {
    // Team invite notification
    if (viewModel is TeamInviteNotificationViewModel) {
      return Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
              Icons.groups,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text('Team Invite: ${viewModel.teamInvite.teamName}'),
          subtitle: Text('${viewModel.inviterName} invited you to join'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: () => _acceptTeamInvite(viewModel),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => _declineTeamInvite(viewModel),
              ),
            ],
          ),
        ),
      );
    }

    // Team invite accepted notification
    if (viewModel is TeamInviteAcceptedNotificationViewModel) {
      return Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: const Icon(Icons.check, color: Colors.white),
          ),
          title: Text('${viewModel.inviteeName} joined your team'),
          subtitle: Text(viewModel.teamInviteAccepted.teamName),
          onTap: () => context.pushNamed(
            'team-detail',
            pathParameters: {'id': viewModel.teamInviteAccepted.teamId},
          ),
        ),
      );
    }

    // Team removed notification
    if (viewModel is TeamRemovedNotificationViewModel) {
      return Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.orange,
            child: const Icon(Icons.exit_to_app, color: Colors.white),
          ),
          title: const Text('Removed from team'),
          subtitle:
              Text('You were removed from ${viewModel.teamRemoved.teamName}'),
        ),
      );
    }

    // Team captaincy received notification
    if (viewModel is TeamCaptaincyReceivedNotificationViewModel) {
      return Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.amber,
            child: const Icon(Icons.star, color: Colors.white),
          ),
          title: Text(
              'You are now captain of ${viewModel.captaincyReceived.teamName}'),
          subtitle: Text(
              '${viewModel.previousCaptainName} transferred captaincy to you'),
          onTap: () => context.pushNamed(
            'team-detail',
            pathParameters: {'id': viewModel.captaincyReceived.teamId},
          ),
        ),
      );
    }

    // Unknown/legacy notification
    if (viewModel is UnknownNotificationViewModel) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notification'),
          subtitle: Text('Type: ${viewModel.type}'),
        ),
      );
    }

    return Container();
  }

  Future<void> _acceptTeamInvite(
      TeamInviteNotificationViewModel viewModel) async {
    try {
      await locate<TeamsService>().acceptInvite(viewModel.teamInvite.inviteId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Joined ${viewModel.teamInvite.teamName}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to accept invite: $e')),
        );
      }
    }
  }

  Future<void> _declineTeamInvite(
      TeamInviteNotificationViewModel viewModel) async {
    try {
      await locate<TeamsService>().declineInvite(viewModel.teamInvite.inviteId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invite declined')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to decline invite: $e')),
        );
      }
    }
  }
}
