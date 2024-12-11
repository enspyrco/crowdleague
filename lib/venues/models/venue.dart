class Venue {
  Venue({
    required this.id,
    required this.size,
    required this.surface,
    required this.environment,
    required this.name,
    required this.address,
    required this.largePhotoUrl,
    required this.iconUrl,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final int size; // 1 half-court, 2 full-court, 3 multi-court
  final int surface; // concrete, wood, astro-turf
  final int environment; // outdoor, indoor, outdoor-with-cover
  final String name;
  final String address;
  final String largePhotoUrl;
  final String iconUrl;
  final double latitude;
  final double longitude;

  factory Venue.fromJson(Map<String, Object?> json) {
    return Venue(
      id: json['id'] as String,
      size: json['size'] as int,
      surface: json['surface'] as int,
      environment: json['environment'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      largePhotoUrl: json['largePhotoUrl'] as String,
      iconUrl: json['iconUrl'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }
}
