import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:crowdleague/services/venues_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/geo_location_service.dart';
import '../utils/locator.dart';
import 'venue.dart';

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
  final Set<Marker> _markers = {};

  Future<void> _goToCurrentLocation() async {
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
  }

  Future<void> _displayVenues() async {
    final venues = await locate<VenuesService>().retrieveVenues();
    _markers.clear();
    for (final Venue venue in venues) {
      final http.Response response = await http.get(Uri.parse(venue.iconUrl));
      final descriptor = BitmapDescriptor.bytes(response.bodyBytes);
      final marker = Marker(
        markerId: MarkerId(venue.id),
        position: LatLng(venue.latitude, venue.longitude),
        icon: descriptor,
      );
      _markers.add(marker);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _goToCurrentLocation();
    _displayVenues();
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
          markers: _markers,
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
