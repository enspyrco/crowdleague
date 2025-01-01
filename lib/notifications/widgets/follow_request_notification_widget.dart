import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../services/players_service.dart';
import '../../services/user_service.dart';
import '../../utils/avatar.dart';
import '../../utils/locator.dart';
import '../models/notifications.dart';

class FollowRequestNotificationWidget extends StatefulWidget {
  const FollowRequestNotificationWidget({
    required this.notification,
    super.key,
  });

  final FollowRequestNotification notification;

  @override
  State<FollowRequestNotificationWidget> createState() =>
      _FollowRequestNotificationStateWidgetFollowRequestNotificationWidget();
}

class _FollowRequestNotificationStateWidgetFollowRequestNotificationWidget
    extends State<FollowRequestNotificationWidget> {
  Future<void> _declineFollowRequest(
      FollowRequestNotification notification) async {
    locate<UserService>().declineFollowRequest(
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

          return FutureBuilder<Uint8List?>(
              future:
                  locate<PlayersService>().retrieveSmallProfilePic(player.id),
              builder: (context, snapshot) {
                return Card(
                  child: ListTile(
                    leading: (snapshot.data != null)
                        ? Avatar(picBytes: snapshot.data!)
                        : Avatar(loading: true),
                    title: Text('${player.name} wants to follow you'),
                    subtitle: Row(
                      children: [
                        if (!widget.notification.waiting) ...[
                          TextButton(
                              onPressed: () {
                                locate<UserService>().acceptFollowRequest(
                                  requesterId: player.id,
                                  requesteeId: widget.notification.requesteeId,
                                  notificationId: widget.notification.id,
                                );
                              },
                              child: Text('Accept')),
                          TextButton(
                            onPressed: () {
                              _declineFollowRequest(widget.notification);
                            },
                            child: Text('Decline'),
                          ),
                        ] else
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
