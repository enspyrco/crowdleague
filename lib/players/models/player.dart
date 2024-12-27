class Player {
  final String id;
  final String name;
  final List<String> pendingTeamRequests;

  const Player({
    required this.id,
    required this.name,
    required this.pendingTeamRequests,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'teamRequests': pendingTeamRequests,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      pendingTeamRequests: (json['pendingTeamRequests'] == null)
          ? []
          : List<String>.from(json['pendingTeamRequests']),
    );
  }

  @override
  String toString() {
    return 'Player{id: $id, name: $name, pendingTeamRequests: $pendingTeamRequests}';
  }
}

class EmptyPlayer extends Player {
  const EmptyPlayer(
      {super.id = '', super.name = '?', super.pendingTeamRequests = const []});
}
