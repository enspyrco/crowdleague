import 'package:crowdleague/players/enums/pic_size.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'players_service.dart';
import '../services/user_service.dart';
import '../utils/widgets/avatar.dart';
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
      appBar: AppBar(
        title: const Text('Find Players'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _nameTextController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          FutureBuilder<List<Player>>(
              future: locate<PlayersService>().retrievePlayers(),
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
                          leading: Avatar(
                            playerId: playerId,
                            picSize: PicSize.small,
                            size: 40,
                          ),
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
