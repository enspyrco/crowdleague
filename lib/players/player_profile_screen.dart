import 'package:crowdleague/players/enums/pic_size.dart';
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
  bool _owner = false; // if the profile is the user's profile

  @override
  void initState() {
    super.initState();
    _owner = widget._playerId == locate<UserAuthService>().currentUserId!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<Player?>(
          stream: locate<PlayersService>().listenToPlayer(widget._playerId),
          builder: (context, snapshot) {
            final Player player = snapshot.data ?? EmptyPlayer();
            final pending = player.pendingCrewRequests
                .contains(locate<UserAuthService>().currentUserId!);
            final crew = player.crewIds
                .contains(locate<UserAuthService>().currentUserId!);

            return Column(
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
                        widget._playerId,
                        PicSize.large,
                        widgetSize: 100,
                      ),
                      if (_owner)
                        Positioned(
                            bottom: 0.0, right: 0.0, child: Icon(Icons.edit))
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
                      Text(player.name,
                          style: Theme.of(context).textTheme.displayMedium!),
                      if (_owner) Icon(Icons.edit)
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (!_owner && !crew)
                            TextButton(
                              onPressed: pending
                                  ? null
                                  : () => locate<UserService>()
                                      .requestCrew(playerId: widget._playerId),
                              child: pending
                                  ? Text('Pending...')
                                  : Text('Join Crews'),
                            ),
                          if (!_owner && crew)
                            CrewMenuButton(playerId: player.id),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Text('Crew Members'),
                      ),
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: player.crewIds.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: AsyncAvatar(
                                  player.crewIds[index],
                                  PicSize.small,
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
