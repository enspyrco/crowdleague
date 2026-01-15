import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../players/enums/pic_size.dart';
import '../../players/models/player.dart';
import '../../utils/locator.dart';
import '../models/venue.dart';
import '../venues_service.dart';

class VenueCrewScreen extends StatefulWidget {
  const VenueCrewScreen({required this.venueId, super.key});

  final String venueId;

  @override
  State<VenueCrewScreen> createState() => _VenueCrewScreenState();
}

class _VenueCrewScreenState extends State<VenueCrewScreen> {
  Venue? _venue;
  List<Player>? _crewMembers;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final venue = await locate<VenuesService>().retrieveVenue(widget.venueId);
    final members =
        await locate<VenuesService>().getVenueCrewMembers(widget.venueId);

    if (mounted) {
      setState(() {
        _venue = venue;
        _crewMembers = members;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_venue?.name ?? 'Crew Members'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _crewMembers == null || _crewMembers!.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.group_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No crew members yet'),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _crewMembers!.length,
                  itemBuilder: (context, index) {
                    final member = _crewMembers![index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: member.picId != 0
                            ? NetworkImage(
                                member.constructProfilePicUrl(PicSize.small),
                              )
                            : null,
                        onBackgroundImageError: (_, __) {},
                        child: member.picId == 0
                            ? Text(member.name.isNotEmpty
                                ? member.name[0].toUpperCase()
                                : '?')
                            : null,
                      ),
                      title: Text(member.name),
                      onTap: () => context.push('/player-profile/${member.id}'),
                    );
                  },
                ),
    );
  }
}
