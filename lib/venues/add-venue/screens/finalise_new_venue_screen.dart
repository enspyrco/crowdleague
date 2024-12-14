import 'package:crowdleague/venues/models/local_venue.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../services/auth_service.dart';
import '../../../services/venues_service.dart';
import '../../../utils/locator.dart';
import '../../models/upload_event.dart';
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
  String _progressMessage = 'Initializing upload...';

  Future<void> _createVenue(String name, String address) async {
    // Update the name & address of the LocalVenue stored in the VenuesService
    locate<VenuesService>().updateLocalVenue(
      name: name,
      address: address,
      createdBy: locate<AuthService>().currentUserId!,
    );

    if (mounted) {
      setState(() {
        _uploading = true;
      });
    }
    final venueId = await locate<VenuesService>().createNewVenue();

    //  Upload large photo file
    if (mounted) {
      setState(() {
        _progressMessage = 'Uploading venue photo...';
      });
    }
    await for (final UploadEvent _ in locate<VenuesService>().uploadFile(
      storagePath: 'venuePhotos/${venueId}_large',
    )) {}
    final String largePhotoUrl = await locate<VenuesService>()
        .getDownloadUrl('venuePhotos/${venueId}_large');

    // Upload bytes for map icon and get a download Url
    if (mounted) {
      setState(() {
        _progressMessage = 'Creating and uploading map icon...';
      });
    }
    await for (final _ in locate<VenuesService>()
        .uploadIconBytes(storagePath: 'venuePhotos/${venueId}_icon')) {}
    final String iconUrl = await locate<VenuesService>()
        .getDownloadUrl('venuePhotos/${venueId}_icon');

    await locate<VenuesService>()
        .updateVenue(id: venueId, data: // add photo Urls to venue
            {'largePhotoUrl': largePhotoUrl, 'iconUrl': iconUrl});

    if (mounted) {
      setState(() {
        _uploading = false;
      });
      context.go('/');
    }
  }

  Future<void> _getStreetAddress() async {
    String address = await locate<VenuesService>()
        .retrieveAddress(widget.latitude, widget.longitude);
    if (mounted) {
      setState(() {
        _addressController.text = address;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    locate<VenuesService>().updateLocalVenue(latLng: (
      double.parse(widget.latitude),
      double.parse(widget.longitude),
    ));
    _getStreetAddress();
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
              body: (_uploading)
                  ? Column(
                      children: [
                        const LinearProgressIndicator(),
                        Expanded(
                          child: Center(
                            child: Text(_progressMessage),
                          ),
                        )
                      ],
                    )
                  : ListView(
                      children: [
                        if (!_uploading) ...[
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
                          if (snapshot.data != null &&
                              snapshot.data!.size != 3) ...[
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
                      ],
                    ));
        });
  }
}
