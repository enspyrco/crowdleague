class Venue {
  Venue({
    required this.facing,
    required this.id,
    required this.name,
    required this.type,
    required this.photoUrl,
  });

  final String id;
  final int type;
  final int facing;
  final String name;
  final String photoUrl;
}
