import 'package:flutter/material.dart';

import '../../services/players_service.dart';
import '../../utils/async_avatar.dart';
import '../../utils/locator.dart';
import '../models/notifications.dart';

class CrewAcceptedNotificationWidget extends StatefulWidget {
  const CrewAcceptedNotificationWidget(this.notification, {super.key});

  final CrewAcceptedNotification notification;

  @override
  State<CrewAcceptedNotificationWidget> createState() =>
      _CrewAcceptedNotificationWidgetState();
}

class _CrewAcceptedNotificationWidgetState
    extends State<CrewAcceptedNotificationWidget> {
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
                  title: Text(
                      '${player.name} is in your crew and you are following each other')));
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
