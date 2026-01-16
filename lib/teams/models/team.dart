import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  final String id;
  final String name;
  final String captainId;
  final List<String> memberIds;
  final int? logoId;
  final DateTime createdAt;

  static const int maxRosterSize = 15;

  const Team({
    required this.id,
    required this.name,
    required this.captainId,
    required this.memberIds,
    required this.createdAt,
    this.logoId,
  });

  factory Team.fromJsonWithId(String id, Map<String, dynamic> json) {
    return Team(
      id: id,
      name: json['name'] ?? '',
      captainId: json['captainId'] ?? '',
      memberIds: (json['memberIds'] == null)
          ? []
          : List<String>.from(json['memberIds']),
      logoId: json['logoId'],
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'captainId': captainId,
      'memberIds': memberIds,
      'logoId': logoId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  bool get isFull => memberIds.length >= maxRosterSize;

  int get memberCount => memberIds.length;

  @override
  String toString() {
    return 'Team{id: $id, name: $name, captainId: $captainId, memberIds: $memberIds}';
  }
}
