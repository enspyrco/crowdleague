class Player {
  final String id;
  final String name;
  final int picTimestamp;
  final List<String> pendingCrewRequests;
  final List<String> crewIds;

  const Player({
    required this.id,
    required this.name,
    required this.picTimestamp,
    required this.pendingCrewRequests,
    required this.crewIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'picTimestamp': picTimestamp,
      'crewRequests': pendingCrewRequests,
      'crewIds': crewIds,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      picTimestamp: json['picTimestamp'],
      pendingCrewRequests: (json['pendingCrewRequests'] == null)
          ? []
          : List<String>.from(json['pendingCrewRequests']),
      crewIds:
          (json['crewIds'] == null) ? [] : List<String>.from(json['crewIds']),
    );
  }

  factory Player.fromJsonWithId(String id, Map<String, dynamic> json) {
    return Player(
      id: id,
      name: json['name'],
      picTimestamp: json['picTimestamp'],
      pendingCrewRequests: (json['pendingCrewRequests'] == null)
          ? []
          : List<String>.from(json['pendingCrewRequests']),
      crewIds:
          (json['crewIds'] == null) ? [] : List<String>.from(json['crewIds']),
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
    super.picTimestamp = 0,
    super.pendingCrewRequests = const [],
    super.crewIds = const [],
  });
}
