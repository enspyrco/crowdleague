import 'dart:async';

import 'package:crowdleague/services/venues_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/geo_location_service.dart';
import '../utils/locator.dart';

class AddVenueLocationScreen extends StatefulWidget {
  const AddVenueLocationScreen({super.key});

  static const CameraPosition _kMelbourne = CameraPosition(
    target: LatLng(-37.840935, 144.946457),
    zoom: 15,
  );

  @override
  State<AddVenueLocationScreen> createState() => _AddVenueLocationScreenState();
}

class _AddVenueLocationScreenState extends State<AddVenueLocationScreen> {
  final Completer<GoogleMapController> _controllerCompleter =
      Completer<GoogleMapController>();

  LatLng? _currentLocation;
  bool _isLoading = true;

  Marker _marker = const Marker(
    markerId: MarkerId('center'),
    position: LatLng(-37.840935, 144.946457),
    draggable: false,
  );

  Future<void> _getLocation() async {
    final latLngRecord = await locate<GeoLocationService>().determinePosition();
    LatLng location = LatLng(latLngRecord.$1, latLngRecord.$2);
    _currentLocation = location;
  }

  Future<void> _goToCurrentLocation() async {
    final controller = await _controllerCompleter.future;
    if (mounted) {
      _isLoading = false;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: _currentLocation ?? const LatLng(0, 0), zoom: 15)));
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocation().then((_) => _goToCurrentLocation());
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
                locate<VenuesService>().createNewVenue(
                  at: (_marker.position.latitude, _marker.position.longitude),
                );
                context.push('/configure-venue');
              },
              icon: const Icon(Icons.check))
        ]),
        body: Stack(
          children: [
            GoogleMap(
              myLocationEnabled: true,
              markers: {_marker},
              initialCameraPosition: (_currentLocation == null)
                  ? AddVenueLocationScreen._kMelbourne
                  : CameraPosition(target: _currentLocation!),
              onMapCreated: (GoogleMapController controller) {
                _controllerCompleter.complete(controller);
              },
              onCameraMove: (cameraPosition) {
                setState(() {
                  _marker =
                      _marker.copyWith(positionParam: cameraPosition.target);
                });
              },
            ),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ));
  }
}
