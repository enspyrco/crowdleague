import '../../utils/globals.dart';
import '../enums/pic_size.dart';

class Player {
  final String id;
  final String name;
  final int picId;
  final List<int> picIds;
  final String picStatus;
  final List<String> pendingCrewRequests;
  final List<String> crewIds;

  const Player({
    required this.id,
    required this.name,
    required this.picId,
    required this.picIds,
    required this.picStatus,
    required this.pendingCrewRequests,
    required this.crewIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'picId': picId,
      'picIds': picIds,
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
      picIds: json['picIds'] == null ? [] : List<int>.from(json['picIds']),
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
      picIds: json['picIds'] == null ? [] : List<int>.from(json['picIds']),
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

  String constructProfilePicUrl(PicSize picSize) {
    final String picUriString;
    if (picSize == PicSize.small) {
      picUriString = 'profiles/$id/${picId}_small.jpg';
    } else if (picSize == PicSize.medium) {
      picUriString = 'profiles/$id/${picId}_medium.jpg';
    } else {
      picUriString = 'profiles/$id/${picId}_large.jpg';
    }
    return 'https://storage.googleapis.com/$kBucketName/$picUriString';
  }
}

class EmptyPlayer extends Player {
  const EmptyPlayer({
    super.id = '',
    super.name = '?',
    super.picId = 0,
    super.picIds = const [],
    super.picStatus = '',
    super.pendingCrewRequests = const [],
    super.crewIds = const [],
  });
}
