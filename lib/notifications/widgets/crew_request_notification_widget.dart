import 'package:flutter/material.dart';

import '../../players/enums/pic_size.dart';
import '../../services/players_service.dart';
import '../../services/user_service.dart';
import '../../utils/async_avatar.dart';
import '../../utils/locator.dart';
import '../models/notifications.dart';

class CrewRequestNotificationWidget extends StatefulWidget {
  const CrewRequestNotificationWidget(this.notification, {super.key});

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
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.white,
            child: ListTile(
              leading: AsyncAvatar(player.id, PicSize.small),
              title: Text(
                '${player.name} wants to join crews',
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
              subtitle: Row(
                children: [
                  if (!widget.notification.waiting) ...[
                    OutlinedButton(
                      onPressed: () {
                        locate<UserService>().acceptCrewRequest(
                          requesterId: player.id,
                          requesteeId: widget.notification.requesteeId,
                          notificationId: widget.notification.id,
                        );
                      },
                      child: Text(
                        'Accept',
                        style: Theme.of(context).textTheme.bodyMedium!,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        _declineCrewRequest(widget.notification);
                      },
                      child: Text(
                        'Decline',
                        style: Theme.of(context).textTheme.bodyMedium!,
                      ),
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
