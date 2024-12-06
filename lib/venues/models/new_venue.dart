class NewVenue {
  NewVenue({
    this.type = 2,
    this.facing = 1,
    this.name = '',
    this.address = '',
    this.photoUrl = '',
    this.latLng = (0, 0),
  });

  int type; // 1 half-court, 2 full-court, 3 multi-court
  int facing; // 1 east-west, 2 north-south
  String name;
  String address;
  String photoUrl;
  (double, double) latLng;

  Map<String, Object?> toJson() {
    return {
      'type': type,
      'facing': facing,
      'name': name,
      'address': address,
      'photoUrl': photoUrl,
      'latitude': latLng.$1,
      'longitude': latLng.$2,
    };
  }
}
