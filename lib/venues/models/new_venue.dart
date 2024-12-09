class NewVenue {
  NewVenue({
    this.size = 2,
    this.surface = 1,
    this.environment = 1,
    this.name = '',
    this.address = '',
    this.photoUrl = '',
    this.latLng = (0, 0),
    this.iconUrl = '',
    this.largePhotoUrl = '',
  });

  int size; // 1 half-court, 2 full-court, 3 multi-court
  int surface; // concrete, wood, astro-turf
  int environment; // outdoor, indoor, outdoor-with-cover
  String name;
  String address;
  String photoUrl;
  (double, double) latLng;
  String iconUrl;
  String largePhotoUrl;

  Map<String, Object?> toJson() {
    return {
      'size': size,
      'name': name,
      'address': address,
      'photoUrl': photoUrl,
      'latitude': latLng.$1,
      'longitude': latLng.$2,
      'iconUrl': iconUrl,
      'largePhotoUrl': largePhotoUrl,
    };
  }
}
