class Venue {
  Venue({
    required this.facing,
    required this.id,
    required this.name,
    required this.address,
    required this.type,
    required this.photoUrl,
    required this.iconUrl,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final int type;
  final int facing;
  final String name;
  final String address;
  final String photoUrl;
  final String iconUrl;
  final double latitude;
  final double longitude;

  factory Venue.fromJson(Map<String, Object?> json) {
    return Venue(
      facing: json['facing'] as int,
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      photoUrl: json['photoUrl'] as String,
      iconUrl: json['iconUrl'] as String,
      type: json['type'] as int,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }
}
