class Player {
  final String id;
  final String name;
  final List<String> pendingCrewRequests;
  final List<String> crew;

  const Player({
    required this.id,
    required this.name,
    required this.pendingCrewRequests,
    required this.crew,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'crewRequests': pendingCrewRequests,
      'crew': crew,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      pendingCrewRequests: (json['pendingCrewRequests'] == null)
          ? []
          : List<String>.from(json['pendingCrewRequests']),
      crew: (json['crew'] == null) ? [] : List<String>.from(json['crew']),
    );
  }

  @override
  String toString() {
    return 'Player{id: $id, name: $name, pendingCrewRequests: $pendingCrewRequests}';
  }
}

class EmptyPlayer extends Player {
  const EmptyPlayer({
    super.id = '',
    super.name = '?',
    super.pendingCrewRequests = const [],
    super.crew = const [],
  });
}
