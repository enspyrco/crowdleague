import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../services/geo_location_service.dart';
import '../../../utils/locator.dart';

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

  LatLng _currentLocation = LatLng(-37.840935, 144.946457);
  bool _isLoading = true;

  Marker _marker = const Marker(
    markerId: MarkerId('center'),
    position: LatLng(-37.840935, 144.946457),
    draggable: false,
  );

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
              GoogleMap(
                myLocationEnabled: true,
                markers: {_marker},
                initialCameraPosition: CameraPosition(target: _currentLocation),
                onMapCreated: (GoogleMapController controller) {
                  _controllerCompleter.complete(controller);
                },
                onCameraMove: (cameraPosition) {
                  setState(() {
                    _marker =
                        _marker.copyWith(positionParam: cameraPosition.target);
                  });
                  _currentLocation = cameraPosition.target;
                },
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
