import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../services/geo_location_service.dart';
import '../../../utils/locator.dart';
import '../../venues_service.dart';

class SelectNewVenueLocationScreen extends StatefulWidget {
  const SelectNewVenueLocationScreen({super.key});

  @override
  State<SelectNewVenueLocationScreen> createState() =>
      _SelectNewVenueLocationScreenState();
}

class _SelectNewVenueLocationScreenState
    extends State<SelectNewVenueLocationScreen> {
  final Completer<GoogleMapController> _controllerCompleter =
      Completer<GoogleMapController>();

  LatLng _currentLocation = const LatLng(-37.840935, 144.946457);
  bool _isLoading = true;

  Marker _marker = const Marker(
    markerId: MarkerId('center'),
    position: LatLng(-37.840935, 144.946457),
    draggable: false,
  );

  String? _locationError;
  final _searchController = TextEditingController();
  bool _isSearching = false;

  Future<void> _searchAddress() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isSearching = true);

    try {
      final result = await locate<VenuesService>().searchAddress(query);
      if (result != null && mounted) {
        final controller = await _controllerCompleter.future;
        final location = LatLng(result.$1, result.$2);
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: location, zoom: 15),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address not found')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _goToCurrentLocation() async {
    try {
      // wait for the google maps controller and the geolocation
      final (latLngRecord, controller) = await (
        locate<GeoLocationService>().determinePosition(),
        _controllerCompleter.future
      ).wait;
      LatLng location = LatLng(latLngRecord.$1, latLngRecord.$2);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: location, zoom: 15)));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _locationError = e.toString();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _goToCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return const Placeholder();
    }

    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
              onPressed: () {
                context.pushNamed(
                  'finalise-new-venue',
                  pathParameters: {
                    'latitude': _currentLocation.latitude.toString(),
                    'longitude': _currentLocation.longitude.toString()
                  },
                );
              },
              icon: const Icon(Icons.check))
        ]),
        body: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by address',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _isSearching
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                ),
                              )
                            : IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: _searchAddress,
                              ),
                        border: const OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _searchAddress(),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    color: _locationError != null
                        ? Theme.of(context).colorScheme.errorContainer
                        : Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      _locationError != null
                          ? 'Location unavailable. Drag the map or search above.'
                          : 'Drag the map or search above to set venue location.',
                      style: TextStyle(
                        color: _locationError != null
                            ? Theme.of(context).colorScheme.onErrorContainer
                            : Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: GoogleMap(
                      myLocationEnabled: _locationError == null,
                      markers: {_marker},
                      initialCameraPosition:
                          CameraPosition(target: _currentLocation),
                      onMapCreated: (GoogleMapController controller) {
                        _controllerCompleter.complete(controller);
                      },
                      onCameraMove: (cameraPosition) {
                        setState(() {
                          _marker = _marker.copyWith(
                              positionParam: cameraPosition.target);
                        });
                        _currentLocation = cameraPosition.target;
                      },
                    ),
                  ),
                ],
              ),
              if (_isLoading) const Center(child: CircularProgressIndicator()),
              Positioned(
                height: constraints.maxHeight - 40,
                width: constraints.maxWidth,
                child: const Icon(
                  Icons.location_pin,
                  size: 45,
                  color: Colors.red,
                ),
              ),
            ],
          );
        }));
  }
}
