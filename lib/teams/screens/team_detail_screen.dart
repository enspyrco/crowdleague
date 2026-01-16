import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../players/enums/pic_size.dart';
import '../../players/models/player.dart';
import '../../utils/locator.dart';
import '../../utils/widgets/avatar.dart';
import '../models/team.dart';
import '../teams_service.dart';

class TeamDetailScreen extends StatefulWidget {
  final String teamId;

  const TeamDetailScreen({super.key, required this.teamId});

  @override
  State<TeamDetailScreen> createState() => _TeamDetailScreenState();
}

class _TeamDetailScreenState extends State<TeamDetailScreen> {
  Team? _team;
  List<Player>? _members;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTeam();
  }

  Future<void> _loadTeam() async {
    setState(() => _isLoading = true);
    try {
      final team = await locate<TeamsService>().getTeam(widget.teamId);
      List<Player>? members;
      if (team != null) {
        members = await locate<TeamsService>().getTeamMembers(widget.teamId);
      }
      if (mounted) {
        setState(() {
          _team = team;
          _members = members;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load team: $e')),
        );
      }
    }
  }

  Future<void> _leaveTeam() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Team'),
        content: const Text('Are you sure you want to leave this team?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await locate<TeamsService>().leaveTeam(widget.teamId);
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to leave team: $e')),
        );
      }
    }
  }

  Future<void> _deleteTeam() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Team'),
        content: const Text(
          'Are you sure you want to delete this team? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await locate<TeamsService>().deleteTeam(widget.teamId);
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete team: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_team == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Team not found')),
      );
    }

    final team = _team!;
    final isCaptain = locate<TeamsService>().isCaptain(team);

    return Scaffold(
      appBar: AppBar(
        title: Text(team.name),
        actions: [
          if (isCaptain)
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'invite':
                    context.pushNamed(
                      'invite-to-team',
                      pathParameters: {'id': widget.teamId},
                    );
                    break;
                  case 'delete':
                    _deleteTeam();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'invite',
                  child: ListTile(
                    leading: Icon(Icons.person_add),
                    title: Text('Invite Player'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete Team',
                        style: TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadTeam,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Team info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        team.name.isNotEmpty ? team.name[0].toUpperCase() : 'T',
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      team.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${team.memberIds.length} / ${Team.maxRosterSize} members',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Members section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Members',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (isCaptain)
                  TextButton.icon(
                    onPressed: () => context.pushNamed(
                      'invite-to-team',
                      pathParameters: {'id': widget.teamId},
                    ),
                    icon: const Icon(Icons.person_add, size: 18),
                    label: const Text('Invite'),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            if (_members != null)
              ...(_members!.map((player) => Card(
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
                      subtitle: player.id == team.captainId
                          ? const Text('Captain',
                              style: TextStyle(color: Colors.orange))
                          : null,
                      trailing: isCaptain && player.id != team.captainId
                          ? PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == 'remove') {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Remove Member'),
                                      content: Text(
                                        'Remove ${player.name} from the team?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text('Remove'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirmed == true) {
                                    try {
                                      await locate<TeamsService>().removeMember(
                                        widget.teamId,
                                        player.id,
                                      );
                                      _loadTeam();
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('Failed to remove: $e'),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                } else if (value == 'transfer') {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Transfer Captaincy'),
                                      content: Text(
                                        'Make ${player.name} the captain?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text('Transfer'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirmed == true) {
                                    try {
                                      await locate<TeamsService>()
                                          .transferCaptaincy(
                                        widget.teamId,
                                        player.id,
                                      );
                                      _loadTeam();
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('Failed to transfer: $e'),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'transfer',
                                  child: Text('Make Captain'),
                                ),
                                const PopupMenuItem(
                                  value: 'remove',
                                  child: Text('Remove'),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ))),

            const SizedBox(height: 24),

            // Leave team button (for non-captains)
            if (!isCaptain)
              OutlinedButton(
                onPressed: _leaveTeam,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text('Leave Team'),
              ),
          ],
        ),
      ),
    );
  }
}
