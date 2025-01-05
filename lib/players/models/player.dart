class Player {
  final String id;
  final String name;
  final List<String> pendingCrewRequests;

  const Player({
    required this.id,
    required this.name,
    required this.pendingCrewRequests,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'crewRequests': pendingCrewRequests,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      pendingCrewRequests: (json['pendingCrewRequests'] == null)
          ? []
          : List<String>.from(json['pendingCrewRequests']),
    );
  }

  @override
  String toString() {
    return 'Player{id: $id, name: $name, pendingCrewRequests: $pendingCrewRequests}';
  }
}

class EmptyPlayer extends Player {
  const EmptyPlayer(
      {super.id = '', super.name = '?', super.pendingCrewRequests = const []});
}
