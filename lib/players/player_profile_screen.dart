import 'package:crowdleague/players/enums/pic_size.dart';
import 'package:crowdleague/conversations/conversations_service.dart';
import 'package:crowdleague/services/user_service.dart';
import 'package:crowdleague/venues/venues_service.dart';
import 'package:crowdleague/venues/models/venue.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'players_service.dart';
import '../utils/widgets/avatar.dart';
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
  bool _owner = false; // if the profile is the user's profile
  bool _findingConversation = false;
  List<Venue> _venueCrews = [];
  bool _loadingVenues = true;

  @override
  void initState() {
    super.initState();
    // Is the profile the user's profile?
    _owner = widget._playerId == locate<UserService>().currentUserId!;
  }

  Future<void> _loadVenueCrews(List<String> venueCrewIds) async {
    if (venueCrewIds.isEmpty) {
      if (mounted) {
        setState(() {
          _venueCrews = [];
          _loadingVenues = false;
        });
      }
      return;
    }

    final venues = <Venue>[];
    for (final venueId in venueCrewIds) {
      final venue = await locate<VenuesService>().retrieveVenue(venueId);
      if (venue != null) {
        venues.add(venue);
      }
    }

    if (mounted) {
      setState(() {
        _venueCrews = venues;
        _loadingVenues = false;
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

            // Load venue crews when player data changes
            if (snapshot.hasData && _loadingVenues) {
              _loadVenueCrews(player.venueCrewIds);
            }

            // Bust the cache so changes like `picStatus` will show up
            locate<PlayersService>()
                .bustCache(locate<UserService>().currentUserId!);

            return Column(
              children: [
                const SizedBox(height: 50),
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
                        const Positioned(
                            bottom: 0.0, right: 0.0, child: Icon(Icons.edit))
                    ],
                  ),
                ),
                const SizedBox(height: 50),
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
                      if (_owner) const Icon(Icons.edit)
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      if (!_owner)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: OutlinedButton.icon(
                            onPressed: (_findingConversation)
                                ? null
                                : () => _openConversation(),
                            icon: const Icon(Icons.chat_bubble_outline),
                            label: (_findingConversation)
                                ? const Text('Opening...')
                                : Text(
                                    'Message ${player.name.split(' ').first}'),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 20, bottom: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Venue Crews',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      if (_loadingVenues)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (_venueCrews.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _owner
                                ? 'You haven\'t joined any venue crews yet'
                                : 'Not a member of any venue crews',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey),
                          ),
                        )
                      else
                        ..._venueCrews.map((venue) => ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.location_on),
                              ),
                              title: Text(venue.name),
                              subtitle: Text(
                                  '${venue.crewMemberIds.length} ${venue.crewMemberIds.length == 1 ? 'member' : 'members'}'),
                              onTap: () =>
                                  context.push('/venue-detail/${venue.id}'),
                            )),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
