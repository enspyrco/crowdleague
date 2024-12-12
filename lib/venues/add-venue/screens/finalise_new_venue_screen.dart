import 'package:crowdleague/venues/models/local_venue.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../services/venues_service.dart';
import '../../../utils/locator.dart';
import '../widgets/court_environment_dropdown.dart';
import '../widgets/court_surface_dropdown.dart';
import '../widgets/divider_with_subheading.dart';
import '../widgets/upload_venue_photo.dart';
import '../widgets/venue_size_dropdown.dart';

class FinaliseNewVenueScreen extends StatefulWidget {
  const FinaliseNewVenueScreen(
      {required this.latitude, required this.longitude, super.key});

  final String latitude;
  final String longitude;

  @override
  State<FinaliseNewVenueScreen> createState() => _FinaliseNewVenueScreenState();
}

class _FinaliseNewVenueScreenState extends State<FinaliseNewVenueScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  bool _uploading = false;

  Future<void> _createVenue(String name, String address) async {
    locate<VenuesService>().updateLocalVenue(
      name: name,
      address: address,
    );

    if (mounted) {
      setState(() {
        _uploading = true;
      });
    }
    await locate<VenuesService>().createNewVenue();
    if (mounted) {
      setState(() {
        _uploading = false;
      });
      context.go('/');
    }
  }

  @override
  void initState() {
    super.initState();
    locate<VenuesService>().updateLocalVenue(latLng: (
      double.parse(widget.latitude),
      double.parse(widget.longitude),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocalVenue>(
        stream: locate<VenuesService>().localVenueStream,
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                actions: [
                  if (snapshot.hasData && snapshot.data!.largePhotoPath != null)
                    IconButton(
                      onPressed: () {
                        _createVenue(
                            _nameController.text, _addressController.text);
                      },
                      icon: const Icon(Icons.check),
                    ),
                ],
              ),
              body: ListView(
                children: [
                  if (_uploading) const LinearProgressIndicator(),
                  const UploadVenuePhoto(),
                  const DividerWithSubheading('Name'),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: _nameController,
                      autofocus: true,
                    ),
                  ),
                  const DividerWithSubheading('Address'),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: _addressController,
                    ),
                  ),
                  const DividerWithSubheading('Size'),
                  const SizedBox(height: 5),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: VenueSizeDropdown(),
                  ),
                  if (snapshot.data != null && snapshot.data!.size != 3) ...[
                    const DividerWithSubheading('Surface'),
                    const Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: CourtSurfaceDropdown(),
                    ),
                    const DividerWithSubheading('Environment'),
                    const Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: CourtEnvironmentDropdown(),
                    ),
                  ],
                ],
              ));
        });
  }
}
