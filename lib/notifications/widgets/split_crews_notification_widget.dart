import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../players/enums/pic_size.dart';
import '../../services/players_service.dart';
import '../../utils/async_avatar.dart';
import '../../utils/locator.dart';
import '../models/notifications.dart';

class SplitCrewsNotificationWidget extends StatefulWidget {
  const SplitCrewsNotificationWidget(this.notification, {super.key});

  final SplitCrewsNotification notification;

  @override
  State<SplitCrewsNotificationWidget> createState() =>
      _SplitCrewsNotificationWidgetState();
}

class _SplitCrewsNotificationWidgetState
    extends State<SplitCrewsNotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          locate<PlayersService>().getPlayer(widget.notification.requesteeId),
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
              title: Text('${player.name}\'s crew was split from yours',
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
