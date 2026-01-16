// The json that comes down from the cloud_firestore methods contains Timestamps
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

sealed class Notification {
  const Notification({
    required this.viewed,
    required this.opened,
    required this.timestamp,
    required this.id,
    required this.playerId,
  });
  final String id;
  final bool viewed;
  final bool opened;
  final Timestamp timestamp;
  final String playerId;

  factory Notification.fromJsonWithId(String id, Map<String, dynamic> json) {
    json['id'] = id;
    return Notification.fromJson(json);
  }

  factory Notification.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      // Old crew notification types - return UnknownNotification for migration
      case 'crew-request':
      case 'crew-accepted':
      case 'split-crew':
        return UnknownNotification(
          id: json['id'] ?? '',
          playerId: json['playerId'] ?? '',
          viewed: json['viewed'] ?? false,
          opened: json['opened'] ?? false,
          timestamp: json['timestamp'],
          type: json['type'],
        );
      // Team notification types
      case 'team-invite':
        return TeamInviteNotification(
          id: json['id'] ?? '',
          playerId: json['playerId'] ?? '',
          viewed: json['viewed'] ?? false,
          opened: json['opened'] ?? false,
          timestamp: json['timestamp'],
          teamId: json['teamId'] ?? '',
          teamName: json['teamName'] ?? '',
          inviterId: json['inviterId'] ?? '',
          inviteId: json['inviteId'] ?? '',
        );
      case 'team-invite-accepted':
        return TeamInviteAcceptedNotification(
          id: json['id'] ?? '',
          playerId: json['playerId'] ?? '',
          viewed: json['viewed'] ?? false,
          opened: json['opened'] ?? false,
          timestamp: json['timestamp'],
          teamId: json['teamId'] ?? '',
          teamName: json['teamName'] ?? '',
          inviteeId: json['inviteeId'] ?? '',
        );
      case 'team-removed':
        return TeamRemovedNotification(
          id: json['id'] ?? '',
          playerId: json['playerId'] ?? '',
          viewed: json['viewed'] ?? false,
          opened: json['opened'] ?? false,
          timestamp: json['timestamp'],
          teamId: json['teamId'] ?? '',
          teamName: json['teamName'] ?? '',
        );
      case 'team-captaincy-received':
        return TeamCaptaincyReceivedNotification(
          id: json['id'] ?? '',
          playerId: json['playerId'] ?? '',
          viewed: json['viewed'] ?? false,
          opened: json['opened'] ?? false,
          timestamp: json['timestamp'],
          teamId: json['teamId'] ?? '',
          teamName: json['teamName'] ?? '',
          previousCaptainId: json['previousCaptainId'] ?? '',
        );
      default:
        return UnknownNotification(
          id: json['id'] ?? '',
          playerId: json['playerId'] ?? '',
          viewed: json['viewed'] ?? false,
          opened: json['opened'] ?? false,
          timestamp: json['timestamp'],
          type: json['type'] ?? 'unknown',
        );
    }
  }

  Map<String, Object?> toJson();
}

/// Placeholder for unknown or deprecated notification types
class UnknownNotification extends Notification {
  final String type;

  const UnknownNotification({
    required this.type,
    required super.id,
    required super.playerId,
    required super.timestamp,
    required super.opened,
    required super.viewed,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'type': type,
      'viewed': viewed,
      'opened': opened,
      'timestamp': timestamp,
    };
  }
}

/// Team invite notification - sent when a captain invites a player
class TeamInviteNotification extends Notification {
  final String teamId;
  final String teamName;
  final String inviterId;
  final String inviteId;

  const TeamInviteNotification({
    required this.teamId,
    required this.teamName,
    required this.inviterId,
    required this.inviteId,
    required super.id,
    required super.playerId,
    required super.timestamp,
    required super.opened,
    required super.viewed,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'type': 'team-invite',
      'teamId': teamId,
      'teamName': teamName,
      'inviterId': inviterId,
      'inviteId': inviteId,
      'viewed': viewed,
      'opened': opened,
      'timestamp': timestamp,
    };
  }
}

/// Notification sent to captain when an invite is accepted
class TeamInviteAcceptedNotification extends Notification {
  final String teamId;
  final String teamName;
  final String inviteeId;

  const TeamInviteAcceptedNotification({
    required this.teamId,
    required this.teamName,
    required this.inviteeId,
    required super.id,
    required super.playerId,
    required super.timestamp,
    required super.opened,
    required super.viewed,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'type': 'team-invite-accepted',
      'teamId': teamId,
      'teamName': teamName,
      'inviteeId': inviteeId,
      'viewed': viewed,
      'opened': opened,
      'timestamp': timestamp,
    };
  }
}

/// Notification sent when a player is removed from a team
class TeamRemovedNotification extends Notification {
  final String teamId;
  final String teamName;

  const TeamRemovedNotification({
    required this.teamId,
    required this.teamName,
    required super.id,
    required super.playerId,
    required super.timestamp,
    required super.opened,
    required super.viewed,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'type': 'team-removed',
      'teamId': teamId,
      'teamName': teamName,
      'viewed': viewed,
      'opened': opened,
      'timestamp': timestamp,
    };
  }
}

/// Notification sent when captaincy is transferred to a player
class TeamCaptaincyReceivedNotification extends Notification {
  final String teamId;
  final String teamName;
  final String previousCaptainId;

  const TeamCaptaincyReceivedNotification({
    required this.teamId,
    required this.teamName,
    required this.previousCaptainId,
    required super.id,
    required super.playerId,
    required super.timestamp,
    required super.opened,
    required super.viewed,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'type': 'team-captaincy-received',
      'teamId': teamId,
      'teamName': teamName,
      'previousCaptainId': previousCaptainId,
      'viewed': viewed,
      'opened': opened,
      'timestamp': timestamp,
    };
  }
}
