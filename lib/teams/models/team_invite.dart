import 'package:cloud_firestore/cloud_firestore.dart';

enum TeamInviteStatus { pending, accepted, declined }

class TeamInvite {
  final String id;
  final String teamId;
  final String teamName;
  final String inviterId;
  final String inviteeId;
  final TeamInviteStatus status;
  final DateTime createdAt;

  const TeamInvite({
    required this.id,
    required this.teamId,
    required this.teamName,
    required this.inviterId,
    required this.inviteeId,
    required this.status,
    required this.createdAt,
  });

  factory TeamInvite.fromJsonWithId(String id, Map<String, dynamic> json) {
    return TeamInvite(
      id: id,
      teamId: json['teamId'] ?? '',
      teamName: json['teamName'] ?? '',
      inviterId: json['inviterId'] ?? '',
      inviteeId: json['inviteeId'] ?? '',
      status: TeamInviteStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TeamInviteStatus.pending,
      ),
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teamId': teamId,
      'teamName': teamName,
      'inviterId': inviterId,
      'inviteeId': inviteeId,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  @override
  String toString() {
    return 'TeamInvite{id: $id, teamId: $teamId, inviteeId: $inviteeId, status: $status}';
  }
}
