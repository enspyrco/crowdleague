import 'package:crowdleague/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/players_service.dart';
import '../services/user_auth_service.dart';
import '../utils/async_avatar.dart';
import '../utils/locator.dart';
import 'models/player.dart';
import 'widgets/crew_menu_button.dart';

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({required String playerId, super.key})
      : _playerId = playerId;

  final String _playerId;

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  bool _pending = false; // if there is a pending crew request
  bool _crew = false;
  bool _owner = false; // if the profile is the user's profile
  Player _player = EmptyPlayer();

  Future<void> _getPlayer() async {
    final player = await locate<PlayersService>().getPlayer(widget._playerId);
    if (mounted) {
      setState(() {
        _player = player ?? EmptyPlayer();
        _pending = _player.pendingCrewRequests
            .contains(locate<UserAuthService>().currentUserId!);
        _crew =
            _player.crewIds.contains(locate<UserAuthService>().currentUserId!);
      });
    }
  }

  Future<void> _requestCrew() async {
    if (mounted) {
      setState(() {
        _pending = true;
      });
    }
    await locate<UserService>().requestCrew(playerId: widget._playerId);
  }

  @override
  void initState() {
    super.initState();
    _getPlayer();
    _owner = widget._playerId == locate<UserAuthService>().currentUserId!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () => (_owner)
                ? context.pushNamed('edit-profile-pic', pathParameters: {
                    'onboarding': 'false',
                  })
                : null,
            child: Stack(
              children: [
                AsyncAvatar(
                    bytesFuture: locate<PlayersService>()
                        .retrieveLargeProfilePic(widget._playerId),
                    size: 100),
                if (_owner)
                  Positioned(bottom: 0.0, right: 0.0, child: Icon(Icons.edit))
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () {
              context.pushNamed('edit-name',
                  pathParameters: {'onboarding': 'false'});
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_player.name,
                    style: Theme.of(context).textTheme.displayMedium!),
                if (_owner) Icon(Icons.edit)
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (!_owner && !_crew)
                      TextButton(
                        onPressed: _pending ? null : () => _requestCrew(),
                        child:
                            _pending ? Text('Pending...') : Text('Join Crews'),
                      ),
                    if (!_owner && _crew) CrewMenuButton(playerId: _player.id),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
