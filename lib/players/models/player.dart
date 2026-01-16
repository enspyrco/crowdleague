import '../../utils/globals.dart';
import '../enums/pic_size.dart';

class Player {
  final String id;
  final String name;
  final int picId;
  final List<String> venueCrewIds;
  final List<String> teamIds;

  const Player({
    required this.id,
    required this.name,
    required this.picId,
    required this.venueCrewIds,
    required this.teamIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'picId': picId,
      'venueCrewIds': venueCrewIds,
      'teamIds': teamIds,
    };
  }

  factory Player.fromJsonWithId(String id, Map<String, dynamic> json) {
    return Player(
      id: id,
      name: json['name'] ?? '',
      picId: json['picId'] ?? 0,
      venueCrewIds: (json['venueCrewIds'] == null)
          ? []
          : List<String>.from(json['venueCrewIds']),
      teamIds:
          (json['teamIds'] == null) ? [] : List<String>.from(json['teamIds']),
    );
  }

  @override
  String toString() {
    return 'Player{id: $id, name: $name, picId: $picId, venueCrewIds: $venueCrewIds, teamIds: $teamIds}';
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
    super.venueCrewIds = const [],
    super.teamIds = const [],
  });
}
