class Venue {
  Venue({
    required this.id,
    required this.size,
    required this.surface,
    required this.environment,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.photoCount,
    required this.crewMemberIds,
    this.bookingPrice,
  });

  final String id;
  final int size; // 1 half-court, 2 full-court, 3 multi-court
  final int surface; // 1 concrete, 2 wood, 3 astro-turf, 4 rubber
  final int environment; // outdoor, indoor, outdoor-with-cover
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String createdBy;
  final int photoCount; // 1-5 photos per venue
  final int? bookingPrice; // Price in cents (e.g., 2000 = $20.00)
  final List<String> crewMemberIds; // Player IDs in this venue's crew

  factory Venue.fromJson(Map<String, Object?> json) {
    return Venue(
      id: json['id'] as String,
      size: json['size'] as int,
      surface: json['surface'] as int,
      environment: json['environment'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      createdBy: json['createdBy'] as String,
      photoCount: (json['photoCount'] as int?) ?? 1, // Default 1 for legacy
      bookingPrice: json['bookingPrice'] as int?,
      crewMemberIds: (json['crewMemberIds'] == null)
          ? []
          : List<String>.from(json['crewMemberIds'] as List),
    );
  }
}
