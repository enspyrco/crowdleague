import 'dart:typed_data';

class LocalVenue {
  LocalVenue({
    this.size = 1,
    this.surface = 1,
    this.environment = 1,
    this.name = '',
    this.address = '',
    this.latitude = 0,
    this.longitude = 0,
  });

  int size; // 1 half-court, 2 full-court, 3 multi-court
  int surface; // 1 concrete, 2 wood, 3 astro-turf, 4 rubber
  int environment; // 1 outdoor, 2 indoor, 3 outdoor-with-cover
  String name;
  String address;
  String? largePhotoPath;
  Uint8List? iconBytes;
  double latitude;
  double longitude;

  Map<String, Object?> toJson() {
    return {
      'size': size,
      'surface': surface,
      'environment': environment,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
