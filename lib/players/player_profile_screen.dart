import 'package:crowdleague/players/enums/pic_size.dart';
import 'package:crowdleague/conversations/conversations_service.dart';
import 'package:crowdleague/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'players_service.dart';
import '../utils/widgets/avatar.dart';
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
  bool _localPending = false; // so we can change pending UI locally on tap
  bool _findingConversation = false;

  @override
  void initState() {
    super.initState();
    // Is the profile the user's profile?
    _owner = widget._playerId == locate<UserService>().currentUserId!;
  }

  // Remove playerId from crew list and tokenId from followerTokens if there
  Future<void> _splitCrewsCallback() async {
    if (mounted) {
      setState(() {
        _localPending = true;
      });
    }
    await locate<UserService>().splitCrews(widget._playerId);
    if (mounted) {
      setState(() {
        _localPending = false;
      });
    }
  }

  Future<void> _openConversation() async {
    setState(() {
      _findingConversation = true;
    });
    final String conversationId = await locate<ConversationsService>()
        .findOrCreateConversation(widget._playerId);
    if (mounted) {
      await context
          .pushNamed('conversation', pathParameters: {'id': conversationId});
      setState(() {
        _findingConversation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<Player?>(
          stream: locate<PlayersService>().listenToPlayer(widget._playerId),
          builder: (context, snapshot) {
            final Player player = snapshot.data ?? EmptyPlayer();
            final bool pending = player.pendingCrewRequests
                .contains(locate<UserService>().currentUserId!);
            final bool crew = player.crewIds
                .contains(locate<UserService>().currentUserId!);

            // Bust the cache so changes like `picStatus` will show up
            locate<PlayersService>()
                .bustCache(locate<UserService>().currentUserId!);

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
                      Avatar(
                        playerId: widget._playerId,
                        picSize: PicSize.medium,
                        size: 100,
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
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: OutlinedButton(
                                onPressed: pending || _localPending
                                    ? null
                                    : () {
                                        setState(() {
                                          _localPending = true;
                                        });
                                        locate<UserService>().requestCrew(
                                            playerId: widget._playerId);
                                      },
                                child: pending || _localPending
                                    ? Text(
                                        'Pending...',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!,
                                      )
                                    : Text(
                                        'Join Crew',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!,
                                      ),
                              ),
                            ),
                          if (!_owner && crew)
                            CrewMenuButton(callback: _splitCrewsCallback),
                          if (!_owner)
                            OutlinedButton(
                              onPressed: (_findingConversation)
                                  ? null
                                  : () => _openConversation(),
                              child: (_findingConversation)
                                  ? Text('Finding conversation...')
                                  : Text('Message'),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 20, bottom: 20),
                        child: Text(
                          'Crew Members',
                          style: Theme.of(context).textTheme.displaySmall!,
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: player.crewIds.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Avatar(
                                  playerId: player.crewIds[index],
                                  picSize: PicSize.small,
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
