import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatelessWidget {
  const Map({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: true,
      myLocationEnabled: true,
      initialCameraPosition:
          CameraPosition(target: LatLng(-37.867512, 144.978973), zoom: 10),
      onMapCreated: (GoogleMapController controller) {},
    );
  }
}
