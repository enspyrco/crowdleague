class Venue {
  Venue({
    required this.facing,
    required this.id,
    required this.name,
    required this.type,
    required this.photoUrl,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final int type;
  final int facing;
  final String name;
  final String photoUrl;
  final double latitude;
  final double longitude;

  factory Venue.fromJson(Map<String, Object?> json) {
    return Venue(
      facing: json['facing'] as int,
      id: json['id'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String,
      type: json['type'] as int,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }
}
