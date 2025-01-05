import 'package:flutter/material.dart';

import '../../services/players_service.dart';
import '../../services/user_service.dart';
import '../../utils/async_avatar.dart';
import '../../utils/locator.dart';
import '../models/notifications.dart';

class CrewRequestNotificationWidget extends StatefulWidget {
  const CrewRequestNotificationWidget({
    required this.notification,
    super.key,
  });

  final CrewRequestNotification notification;

  @override
  State<CrewRequestNotificationWidget> createState() =>
      _CrewRequestNotificationStateWidgetCrewRequestNotificationWidget();
}

class _CrewRequestNotificationStateWidgetCrewRequestNotificationWidget
    extends State<CrewRequestNotificationWidget> {
  Future<void> _declineCrewRequest(CrewRequestNotification notification) async {
    locate<UserService>().declineCrewRequest(
      notification.id,
      notification.requesterId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          locate<PlayersService>().getPlayer(widget.notification.requesterId),
      builder: (context, playerSnapshot) {
        if (playerSnapshot.hasData && playerSnapshot.data != null) {
          final player = playerSnapshot.data!;
          return Card(
            child: ListTile(
              leading: AsyncAvatar(
                  bytesFuture: locate<PlayersService>()
                      .retrieveSmallProfilePic(player.id)),
              title: Text('${player.name} wants to join crews'),
              subtitle: Row(
                children: [
                  if (!widget.notification.waiting) ...[
                    TextButton(
                        onPressed: () {
                          locate<UserService>().acceptCrewRequest(
                            requesterId: player.id,
                            requesteeId: widget.notification.requesteeId,
                            notificationId: widget.notification.id,
                          );
                        },
                        child: Text('Accept')),
                    TextButton(
                      onPressed: () {
                        _declineCrewRequest(widget.notification);
                      },
                      child: Text('Decline'),
                    ),
                  ] else
                    Text('Updating crew members...'),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
