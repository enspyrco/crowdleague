import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../services/players_service.dart';
import '../../utils/avatar.dart';
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

          return FutureBuilder<Uint8List?>(
              future:
                  locate<PlayersService>().retrieveSmallProfilePic(player.id),
              builder: (context, snapshot) {
                return Card(
                  child: ListTile(
                    leading: (snapshot.data != null)
                        ? Avatar(picBytes: snapshot.data!)
                        : Avatar(loading: true),
                    title: Text(
                        '${player.name} is now crew and you are following each other'),
                  ),
                );
              });
        } else {
          return Container();
        }
      },
    );
  }
}
