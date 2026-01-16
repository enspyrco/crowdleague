import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../players/enums/pic_size.dart';
import '../../players/models/player.dart';
import '../../players/players_service.dart';
import '../../services/user_service.dart';
import '../../utils/locator.dart';
import '../../utils/widgets/avatar.dart';
import '../models/team.dart';
import '../teams_service.dart';

class InviteToTeamScreen extends StatefulWidget {
  final String teamId;

  const InviteToTeamScreen({super.key, required this.teamId});

  @override
  State<InviteToTeamScreen> createState() => _InviteToTeamScreenState();
}

class _InviteToTeamScreenState extends State<InviteToTeamScreen> {
  final _searchController = TextEditingController();
  List<Player>? _allPlayers;
  List<Player>? _filteredPlayers;
  Team? _team;
  bool _isLoading = true;
  final Set<String> _invitingPlayerIds = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final team = await locate<TeamsService>().getTeam(widget.teamId);
      final players = await locate<PlayersService>().retrievePlayers();

      // Filter out current user and existing team members
      final currentUserId = locate<UserService>().currentUserId;
      final eligiblePlayers = players.where((p) {
        if (p.id == currentUserId) return false;
        if (team != null && team.memberIds.contains(p.id)) return false;
        return true;
      }).toList();

      if (mounted) {
        setState(() {
          _team = team;
          _allPlayers = eligiblePlayers;
          _filteredPlayers = eligiblePlayers;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load players: $e')),
        );
      }
    }
  }

  void _filterPlayers(String query) {
    if (_allPlayers == null) return;

    setState(() {
      if (query.isEmpty) {
        _filteredPlayers = _allPlayers;
      } else {
        _filteredPlayers = _allPlayers!
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _invitePlayer(Player player) async {
    if (_team == null) return;

    // Check roster limit
    if (_team!.memberIds.length >= Team.maxRosterSize) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Team roster is full')),
      );
      return;
    }

    setState(() => _invitingPlayerIds.add(player.id));

    try {
      await locate<TeamsService>().inviteToTeam(widget.teamId, player.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invited ${player.name}')),
        );
        // Remove invited player from list
        setState(() {
          _allPlayers?.removeWhere((p) => p.id == player.id);
          _filteredPlayers?.removeWhere((p) => p.id == player.id);
          _invitingPlayerIds.remove(player.id);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _invitingPlayerIds.remove(player.id));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to invite: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Players'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search by name',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _filterPlayers,
                  ),
                ),
                if (_team != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Team: ${_team!.name} '
                      '(${_team!.memberIds.length}/${Team.maxRosterSize})',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                const SizedBox(height: 8),
                Expanded(
                  child: _filteredPlayers == null || _filteredPlayers!.isEmpty
                      ? Center(
                          child: Text(
                            _searchController.text.isEmpty
                                ? 'No players available to invite'
                                : 'No players found',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredPlayers!.length,
                          itemBuilder: (context, index) {
                            final player = _filteredPlayers![index];
                            final isInviting =
                                _invitingPlayerIds.contains(player.id);

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              child: ListTile(
                                onTap: () => context.pushNamed(
                                  'player-profile',
                                  pathParameters: {'id': player.id},
                                ),
                                leading: Avatar(
                                  playerId: player.id,
                                  picSize: PicSize.small,
                                  size: 40,
                                ),
                                title: Text(player.name),
                                trailing: isInviting
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : IconButton(
                                        icon: const Icon(Icons.person_add),
                                        onPressed: () => _invitePlayer(player),
                                      ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
