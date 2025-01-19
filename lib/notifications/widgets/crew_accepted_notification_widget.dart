import 'package:crowdleague/players/enums/pic_size.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.white,
            child: ListTile(
              onTap: () {
                context.pushNamed('player-profile',
                    pathParameters: {'id': player.id});
              },
              leading: AsyncAvatar(player.id, PicSize.small),
              title: Text(
                  '${player.name} is in your crew and you are following each other',
                  style: Theme.of(context).textTheme.bodyLarge!),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
