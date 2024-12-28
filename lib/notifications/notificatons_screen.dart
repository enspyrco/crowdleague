import 'dart:typed_data';

import 'package:crowdleague/services/players_service.dart';
import 'package:crowdleague/utils/avatar.dart';
import 'package:crowdleague/utils/locator.dart';
import 'package:flutter/material.dart' hide Notification;

import '../services/user_service.dart';
import 'models/notification.dart';

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
        padding: EdgeInsets.all(8.0),
        child: FutureBuilder<List<Notification>>(
          future: locate<UserService>().retrieveNotifications(),
          builder: (context, notificatiosnSnapshot) {
            if (notificatiosnSnapshot.hasData) {
              return ListView.builder(
                itemCount: notificatiosnSnapshot.data!.length,
                itemBuilder: (context, index) {
                  final Notification notification =
                      notificatiosnSnapshot.data![index];
                  if (notification is TeamUpRequestNotification) {
                    return FutureBuilder(
                      future: locate<PlayersService>()
                          .getPlayer(notification.requesterId),
                      builder: (context, playerSnapshot) {
                        if (playerSnapshot.hasData &&
                            playerSnapshot.data != null) {
                          final player = playerSnapshot.data!;

                          return FutureBuilder<Uint8List?>(
                              future: locate<PlayersService>()
                                  .retrieveSmallProfilePic(player.id),
                              builder: (context, snapshot) {
                                return Card(
                                  child: ListTile(
                                    leading: (snapshot.data != null)
                                        ? Avatar(picBytes: snapshot.data!)
                                        : Avatar(loading: true),
                                    title:
                                        Text('${player.name} wants to team up'),
                                    subtitle: Row(
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              locate<UserService>()
                                                  .acceptTeamRequest();
                                            },
                                            child: Text('Accept')),
                                        TextButton(
                                            onPressed: () {},
                                            child: Text('Decline')),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return Center(child: Text('1'));
                        }
                      },
                    );
                  } else {
                    return Center(child: Text('5'));
                  }
                },
              );
              // return ListView.builder(
              //   itemBuilder: (context, index) {
              //     if (notificatiosnSnapshot.hasData) {
              //       if (notificatiosnSnapshot.data!.isEmpty) {
              //         return Container(child: Center(child: Text('5')));
              //       }
              //       final Notification notification =
              //           notificatiosnSnapshot.data![index];
              //       if (notification is TeamUpRequestNotification) {
              //         return FutureBuilder(
              //           future: locate<PlayersService>()
              //               .getPlayer(notification.requesterId),
              //           builder: (context, playerSnapshot) {
              //             if (playerSnapshot.hasData &&
              //                 playerSnapshot.data != null) {
              //               return Card(
              //                 child: ListTile(
              //                   leading: Icon(Icons.notifications_sharp),
              //                   title: Text('Notification 1'),
              //                   subtitle: Text('This is a notification'),
              //                 ),
              //               );
              //             } else {
              //               return Container(child: Center(child: Text('1')));
              //             }
              //           },
              //         );
              //       } else {
              //         return Container(child: Center(child: Text('2')));
              //       }
              //     } else {
              //       return Container(child: Center(child: Text('3')));
              //     }
              //   },
              // );
            } else {
              return Center(child: Text('4'));
            }
          },
        ),
      ),
    );
  }
}
