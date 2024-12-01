import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/venues_service.dart';
import '../utils/locator.dart';
import 'new_venue.dart';
import 'venue_facing_dropdown.dart';
import 'venue_type_dropdown.dart';

class ConfigureVenueScreen extends StatefulWidget {
  const ConfigureVenueScreen({super.key});

  @override
  State<ConfigureVenueScreen> createState() => _ConfigureVenueScreenState();
}

class _ConfigureVenueScreenState extends State<ConfigureVenueScreen> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          StreamBuilder<NewVenue>(
              stream: null,
              builder: (context, snapshot) {
                return IconButton(
                    onPressed: () {
                      locate<VenuesService>()
                          .updateNewVenue(name: _nameController.text);
                      context.push('/finalise-venue');
                    },
                    icon: const Icon(Icons.check));
              })
        ],
      ),
      body: Center(
        child: StreamBuilder<NewVenue>(
          stream: locate<VenuesService>().newVenueStream,
          builder: (context, snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 100, right: 100),
                      child: TextField(
                        controller: _nameController,
                        autofocus: true,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text('Name'),
                    ),
                  ],
                ),
                const VenueTypeDropdown(),
                if (snapshot.data != null && snapshot.data!.type != 1)
                  const VenueFacingDropdown(),
              ],
            );
          },
        ),
      ),
    );
  }
}
