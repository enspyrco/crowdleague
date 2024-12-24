import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/players_service.dart';
import '../utils/avatar.dart';
import '../utils/locator.dart';

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({required String playerId, super.key})
      : _playerId = playerId;

  final String _playerId;

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: FutureBuilder<Uint8List?>(
                future: locate<PlayersService>()
                    .retrieveLargeProfilePic(widget._playerId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Avatar(picBytes: snapshot.data, size: 100);
                  } else {
                    return Avatar(loading: true, size: 100);
                  }
                }),
          ),
          FutureBuilder<Map<String, Object?>?>(
              future: locate<PlayersService>().getPlayer(widget._playerId),
              builder: (context, snapshot) {
                return Text(snapshot.data?['name'] as String? ?? '?',
                    style: Theme.of(context).textTheme.displayMedium!);
              }),
          Expanded(
            child: ListView(
              children: [
                Card(
                  child: ListTile(
                    title: const Text('Team Up'),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
