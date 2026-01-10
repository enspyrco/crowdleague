import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../services/user_service.dart';
import '../../venues_service.dart';
import '../../../utils/locator.dart';
import '../../models/local_venue.dart';
import '../../models/upload_event.dart';
import '../widgets/court_environment_dropdown.dart';
import '../widgets/court_surface_dropdown.dart';
import '../../../utils/widgets/divider_with_subheading.dart';
import '../widgets/upload_venue_photos.dart';
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

  /// A local copy of the venue for local state that we can listen to, in order
  /// to update the UI when certain values change, eg. multi-venue has no
  /// surface value.
  final _localVenue = LocalVenue();

  Future<void> _createVenue(String name, String address) async {
    // Update the name & address of the LocalVenue stored in the VenuesService
    _localVenue.name = name;
    _localVenue.address = address;
    _localVenue.createdBy = locate<UserService>().currentUserId!;

    if (mounted) {
      setState(() {
        _uploading = true;
      });
    }
    final venueId =
        await locate<VenuesService>().createNewVenue(_localVenue.toJson());

    // Upload all photos with indexed naming
    for (int i = 0; i < _localVenue.photoPaths.length; i++) {
      if (mounted) {
        setState(() {
          _progressMessage =
              'Uploading photo ${i + 1} of ${_localVenue.photoPaths.length}...';
        });
      }
      await for (final UploadEvent _ in locate<VenuesService>().uploadFile(
        localPath: _localVenue.photoPaths[i],
        storagePath: '${venueId}_$i.jpg',
      )) {}
    }

    // Upload bytes for map icon
    if (mounted) {
      setState(() {
        _progressMessage = 'Creating and uploading map icon...';
      });
    }
    await for (final _ in locate<VenuesService>().uploadBytes(
        bytes: _localVenue.iconBytes!,
        storagePath: '${venueId}_icon')) {}

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

  void _onPhotosChanged() {
    setState(() {});
  }

  void updateVenueSizeState(int size) {
    setState(() {
      _localVenue.size = size;
    });
  }

  @override
  void initState() {
    super.initState();
    _localVenue.latitude = double.parse(widget.latitude);
    _localVenue.longitude = double.parse(widget.longitude);
    _getStreetAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            // only allow creating the venue when the user has picked at least one photo
            if (_localVenue.photoPaths.isNotEmpty)
              IconButton(
                onPressed: () {
                  _createVenue(_nameController.text, _addressController.text);
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
                    UploadVenuePhotos(
                      localVenue: _localVenue,
                      onPhotosChanged: _onPhotosChanged,
                    ),
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
                    Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: VenueSizeDropdown(
                        localVenue: _localVenue,
                        updateStateCallback: updateVenueSizeState,
                      ),
                    ),
                    if (_localVenue.size != 3) ...[
                      const DividerWithSubheading('Surface'),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: CourtSurfaceDropdown(
                          localVenue: _localVenue,
                        ),
                      ),
                      const DividerWithSubheading('Environment'),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: CourtEnvironmentDropdown(
                          localVenue: _localVenue,
                        ),
                      ),
                    ],
                  ],
                ],
              ));
  }
}
