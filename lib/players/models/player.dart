class Player {
  final String id;
  final String name;
  final int picId;
  final String picStatus;
  final List<String> pendingCrewRequests;
  final List<String> crewIds;

  const Player({
    required this.id,
    required this.name,
    required this.picId,
    required this.picStatus,
    required this.pendingCrewRequests,
    required this.crewIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'picId': picId,
      'picStatus': picStatus,
      'crewRequests': pendingCrewRequests,
      'crewIds': crewIds,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      picId: json['picId'] ?? 0,
      picStatus: json['picStatus'] ?? 'processing',
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
      picId: json['picId'] ?? 0,
      picStatus: json['picStatus'] ?? 'processing',
      pendingCrewRequests: (json['pendingCrewRequests'] == null)
          ? []
          : List<String>.from(json['pendingCrewRequests']),
      crewIds:
          (json['crewIds'] == null) ? [] : List<String>.from(json['crewIds']),
    );
  }

  @override
  String toString() {
    return 'Player{id: $id, name: $name, picId: $picId, pendingCrewRequests: $pendingCrewRequests}';
  }
}

class EmptyPlayer extends Player {
  const EmptyPlayer({
    super.id = '',
    super.name = '?',
    super.picId = 0,
    super.picStatus = '',
    super.pendingCrewRequests = const [],
    super.crewIds = const [],
  });
}
