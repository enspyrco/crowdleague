class Venue {
  Venue({
    required this.id,
    required this.name,
    required this.address,
    required this.size,
    required this.photoUrl,
    required this.iconUrl,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final int size;
  final String name;
  final String address;
  final String photoUrl;
  final String iconUrl;
  final double latitude;
  final double longitude;

  factory Venue.fromJson(Map<String, Object?> json) {
    return Venue(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      photoUrl: json['photoUrl'] as String,
      iconUrl: json['iconUrl'] as String,
      size: json['size'] as int,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }
}
