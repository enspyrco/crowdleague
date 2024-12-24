import 'dart:typed_data';

import 'package:crowdleague/utils/avatar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/players_service.dart';
import '../utils/locator.dart';

class FindTeamMateScreen extends StatefulWidget {
  const FindTeamMateScreen({super.key});

  @override
  State<FindTeamMateScreen> createState() => _FindTeamMateScreenState();
}

class _FindTeamMateScreenState extends State<FindTeamMateScreen> {
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
          FutureBuilder<Set<Map<String, Object?>>>(
              future: locate<PlayersService>().getPlayers(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final playersList = snapshot.data!.toList();
                return Expanded(
                  child: ListView.builder(
                      itemCount: playersList.length,
                      itemBuilder: (context, index) {
                        String playerId = playersList[index]['id'].toString();
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
                          title: Text(playersList[index]['name'].toString()),
                        ));
                      }),
                );
              }),
        ],
      ),
    );
  }
}
