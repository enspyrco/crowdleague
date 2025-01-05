import 'package:crowdleague/services/user_service.dart';
import 'package:flutter/material.dart';

import '../services/players_service.dart';
import '../services/user_auth_service.dart';
import '../utils/async_avatar.dart';
import '../utils/locator.dart';
import 'models/player.dart';

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({required String playerId, super.key})
      : _playerId = playerId;

  final String _playerId;

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  bool _pending = false;
  Player _player = EmptyPlayer();

  Future<void> _getPlayer() async {
    final player = await locate<PlayersService>().getPlayer(widget._playerId);
    if (mounted) {
      setState(() {
        _player = player ?? EmptyPlayer();
        if (_player.pendingCrewRequests
            .contains(locate<UserAuthService>().currentUserId!)) {
          _pending = true;
        }
      });
    }
  }

  Future<void> _requestCrew() async {
    if (mounted) {
      setState(() {
        _pending = true;
      });
    }
    await locate<UserService>().requestCrew(
        requesteeId: widget._playerId,
        requesterId: locate<UserAuthService>().currentUserId!);
  }

  @override
  void initState() {
    super.initState();
    _getPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: AsyncAvatar(
                bytesFuture: locate<PlayersService>()
                    .retrieveLargeProfilePic(widget._playerId),
                size: 100),
          ),
          Text(_player.name, style: Theme.of(context).textTheme.displayMedium!),
          Expanded(
            child: ListView(
              children: [
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: _pending ? null : () => _requestCrew(),
                        child:
                            _pending ? Text('Pending...') : Text('Join Crews'),
                      )
                    ],
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
