import 'dart:typed_data';

class LocalVenue {
  LocalVenue({
    this.size = 0,
    this.surface = 0,
    this.environment = 0,
    this.name = '',
    this.address = '',
    this.latitude = 0,
    this.longitude = 0,
    this.createdBy = '',
  });

  int size; // 0 half-court, 1 full-court, 2 multi-court
  int surface; // 0 concrete, 1 wood, 2 astro-turf, 3 rubber
  int environment; // 0 outdoor, 1 indoor, 2 outdoor-with-cover
  String name;
  String address;

  /// The local file path of the large venue image
  String? largePhotoPath;

  /// The local file path of the small venue image
  String? smallPhotoPath;

  /// The bytes for the venue icon
  Uint8List? iconBytes;
  double latitude;
  double longitude;
  String createdBy;

  Map<String, Object?> toJson() {
    return {
      'size': size,
      'surface': surface,
      'environment': environment,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
    };
  }
}
