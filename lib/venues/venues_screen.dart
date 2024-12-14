import 'dart:async';

import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:crowdleague/services/venues_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/locator.dart';
import 'models/venue.dart';

class VenuesScreen extends StatefulWidget {
  const VenuesScreen({super.key});

  static const CameraPosition _kMelbourne = CameraPosition(
    target: LatLng(-37.840935, 144.946457),
    zoom: 12,
  );

  @override
  State<VenuesScreen> createState() => _VenuesScreenState();
}

class _VenuesScreenState extends State<VenuesScreen> {
  final Completer<GoogleMapController> _controllerCompleter =
      Completer<GoogleMapController>();
  late final String _darkMapStyle;

  LatLng? _currentLocation;
  final Set<Marker> _markers = {};

  Future _loadMapStyles() async {
    _darkMapStyle =
        await rootBundle.loadString('assets/json/dark_mode_style.json');
  }

  Future<void> _openVenueDetailScreen(String id) async {
    String? venueId =
        await context.pushNamed('venue-detail', pathParameters: {'id': id});

    if (venueId != null) {
      Marker marker =
          _markers.firstWhere((marker) => marker.markerId.value == venueId);
      setState(() {
        _markers.remove(marker);
      });
    }
  }

  Future<void> _displayVenues() async {
    final venues = await locate<VenuesService>().retrieveVenues();
    _markers.clear();

    final Map<Venue, BitmapDescriptor> descriptorMap = {};

    // get bytes for icons asynchronously
    await Future.wait(
      venues.map(
        (venue) async {
          final response = await http.get(Uri.parse(venue.iconUrl));
          final descriptor = BitmapDescriptor.bytes(response.bodyBytes);
          descriptorMap[venue] = descriptor;
        },
      ),
    );

    for (final Venue venue in venues) {
      final marker = Marker(
        markerId: MarkerId(venue.id),
        position: LatLng(venue.latitude, venue.longitude),
        icon: descriptorMap[venue]!,
        onTap: () => _openVenueDetailScreen(venue.id),
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
    _loadMapStyles();
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
          style: Theme.of(context).brightness == Brightness.dark
              ? _darkMapStyle
              : null,
          markers: _markers,
          myLocationEnabled: true,
          initialCameraPosition: (_currentLocation == null)
              ? VenuesScreen._kMelbourne
              : CameraPosition(target: _currentLocation!),
          onMapCreated: (GoogleMapController controller) {
            _controllerCompleter.complete(controller);
          },
        ),
      ],
    ));
  }
}
