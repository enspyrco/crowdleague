class Player {
  final String id;
  final String name;
  final List<String> pendingFollowRequests;

  const Player({
    required this.id,
    required this.name,
    required this.pendingFollowRequests,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'followRequests': pendingFollowRequests,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      pendingFollowRequests: (json['pendingFollowRequests'] == null)
          ? []
          : List<String>.from(json['pendingFollowRequests']),
    );
  }

  @override
  String toString() {
    return 'Player{id: $id, name: $name, pendingFollowRequests: $pendingFollowRequests}';
  }
}

class EmptyPlayer extends Player {
  const EmptyPlayer(
      {super.id = '',
      super.name = '?',
      super.pendingFollowRequests = const []});
}
