import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/geo_location_service.dart';
import '../utils/locator.dart';

class VenuesScreen extends StatefulWidget {
  const VenuesScreen({super.key});

  static const CameraPosition _kMelbourne = CameraPosition(
    target: LatLng(-37.840935, 144.946457),
    zoom: 15,
  );

  @override
  State<VenuesScreen> createState() => _VenuesScreenState();
}

class _VenuesScreenState extends State<VenuesScreen> {
  final Completer<GoogleMapController> _controllerCompleter =
      Completer<GoogleMapController>();

  LatLng? _currentLocation;
  bool _isLoading = true;

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
        body: Stack(
      children: [
        GoogleMap(
          myLocationEnabled: true,
          initialCameraPosition: (_currentLocation == null)
              ? VenuesScreen._kMelbourne
              : CameraPosition(target: _currentLocation!),
          onMapCreated: (GoogleMapController controller) {
            _controllerCompleter.complete(controller);
          },
        ),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
    ));
  }
}
