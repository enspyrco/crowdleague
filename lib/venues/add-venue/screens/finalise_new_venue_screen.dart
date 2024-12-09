import 'package:crowdleague/venues/add-venue/widgets/upload_venue_photo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../services/venues_service.dart';
import '../../../utils/locator.dart';
import '../../models/new_venue.dart';
import '../widgets/court_environment_dropdown.dart';
import '../widgets/court_surface_dropdown.dart';
import '../widgets/venue_size_dropdown.dart';

class FinaliseNewVenueScreen extends StatefulWidget {
  const FinaliseNewVenueScreen({super.key});

  @override
  State<FinaliseNewVenueScreen> createState() => _FinaliseNewVenueScreenState();
}

class _FinaliseNewVenueScreenState extends State<FinaliseNewVenueScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              locate<VenuesService>().updateNewVenue(
                  name: _nameController.text, address: _addressController.text);
              context.push('/finalise-new-venue');
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: StreamBuilder<NewVenue>(
        stream: locate<VenuesService>().newVenueStream,
        builder: (context, snapshot) {
          return ListView(
            children: [
              const UploadVenuePhoto(),
              const Divider(),
              Container(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'Name',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: _nameController,
                  autofocus: true,
                ),
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'Address',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: _addressController,
                ),
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'Size',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: VenueSizeDropdown(),
              ),
              if (snapshot.data != null && snapshot.data!.size != 3) ...[
                const Divider(),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'Surface',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: CourtSurfaceDropdown(),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'Environment',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: CourtEnvironmentDropdown(),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
