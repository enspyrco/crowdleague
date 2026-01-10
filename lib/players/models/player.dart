import '../../utils/globals.dart';
import '../enums/pic_size.dart';

class Player {
  final String id;
  final String name;
  final int picId;
  final List<String> pendingCrewRequests;
  final List<String> crewIds;

  const Player({
    required this.id,
    required this.name,
    required this.picId,
    required this.pendingCrewRequests,
    required this.crewIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'picId': picId,
      'crewRequests': pendingCrewRequests,
      'crewIds': crewIds,
    };
  }

  factory Player.fromJsonWithId(String id, Map<String, dynamic> json) {
    return Player(
      id: id,
      name: json['name'] ?? '',
      picId: json['picId'] ?? 0,
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
      picUriString = '$id/${picId}_small.jpg';
    } else if (picSize == PicSize.medium) {
      picUriString = '$id/${picId}_medium.jpg';
    } else {
      picUriString = '$id/${picId}_large.jpg';
    }
    return 'https://storage.googleapis.com/$kProfilesBucket/$picUriString';
  }
}

class EmptyPlayer extends Player {
  const EmptyPlayer({
    super.id = '',
    super.name = '?',
    super.picId = 0,
    super.pendingCrewRequests = const [],
    super.crewIds = const [],
  });
}
