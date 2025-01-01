import 'dart:typed_data';

import 'package:crowdleague/utils/avatar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/players_service.dart';
import '../services/user_service.dart';
import '../utils/locator.dart';
import 'models/player.dart';

class FindPlayersScreen extends StatefulWidget {
  const FindPlayersScreen({super.key});

  @override
  State<FindPlayersScreen> createState() => _FindPlayersScreenState();
}

class _FindPlayersScreenState extends State<FindPlayersScreen> {
  final _nameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(
            controller: _nameTextController,
            autofocus: true,
          ),
          FutureBuilder<Set<Player>>(
              future: locate<PlayersService>().getPlayers(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final playersList = snapshot.data!.toList();
                playersList.removeWhere((element) {
                  return element.id == locate<UserService>().currentUserId;
                });
                return Expanded(
                  child: ListView.builder(
                      itemCount: playersList.length,
                      itemBuilder: (context, index) {
                        String playerId = playersList[index].id;
                        return Card(
                            child: ListTile(
                          onTap: () {
                            context.pushNamed('player-profile',
                                pathParameters: {'id': playerId});
                          },
                          leading: FutureBuilder<Uint8List?>(
                              future: locate<PlayersService>()
                                  .retrieveSmallProfilePic(playerId),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return Avatar(
                                    picBytes: snapshot.data,
                                    size: 40,
                                  );
                                }
                                return Avatar(loading: true, size: 40);
                              }),
                          title: Text(playersList[index].name),
                        ));
                      }),
                );
              }),
        ],
      ),
    );
  }
}
