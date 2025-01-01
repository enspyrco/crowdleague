import 'dart:typed_data';

import 'package:crowdleague/services/user_service.dart';
import 'package:flutter/material.dart';

import '../../services/players_service.dart';
import '../../utils/avatar.dart';
import '../../utils/locator.dart';
import '../models/notifications.dart';

class FollowBackNotificationWidget extends StatefulWidget {
  const FollowBackNotificationWidget(this.notification, {super.key});

  final FollowBackNotification notification;

  @override
  State<FollowBackNotificationWidget> createState() =>
      _FollowBackNotificationWidgetState();
}

class _FollowBackNotificationWidgetState
    extends State<FollowBackNotificationWidget> {
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
                    title: Text('${player.name} is following you'),
                    subtitle: Row(
                      children: [
                        if (!widget.notification.waiting)
                          TextButton(
                            onPressed: () {
                              locate<UserService>().followBack(
                                requesteeId: widget.notification.requesteeId,
                                requesterId: widget.notification.requesterId,
                                notificationId: widget.notification.id,
                              );
                            },
                            child: Text('Follow Back'),
                          )
                        else
                          Text('Waiting...'),
                      ],
                    ),
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
