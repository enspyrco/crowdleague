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

  factory Notification.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'crew-request':
        return CrewRequestNotification(
          id: json['id'] ?? '',
          playerId: json['playerId'] ?? '',
          viewed: json['viewed'] ?? false,
          opened: json['opened'] ?? false,
          waiting: json['waiting'] ?? false,
          requesterId: json['requesterId'],
          requesteeId: json['requesteeId'],
          timestamp: json['timestamp'],
        );
      case 'crew-accepted':
        return CrewAcceptedNotification(
          id: json['id'] ?? '',
          playerId: json['playerId'] ?? '',
          viewed: json['viewed'] ?? false,
          opened: json['opened'] ?? false,
          waiting: json['waiting'] ?? false,
          requesterId: json['requesterId'],
          requesteeId: json['requesteeId'],
          timestamp: json['timestamp'],
        );
      case 'split-crew':
        return SplitCrewsNotification(
          id: json['id'] ?? '',
          playerId: json['playerId'] ?? '',
          viewed: json['viewed'] ?? false,
          opened: json['opened'] ?? false,
          requesterId: json['requesterId'],
          requesteeId: json['requesteeId'],
          timestamp: json['timestamp'],
        );
      default:
        throw Exception('Unknown notification type');
    }
  }

  Map<String, Object?> toJson();
}

class CrewRequestNotification extends Notification {
  final String requesterId;
  final String requesteeId;
  final bool waiting;

  const CrewRequestNotification({
    required this.requesteeId,
    required this.requesterId,
    required this.waiting,
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
      'type': 'follow-request',
      'requesterId': requesterId,
      'requesteeId': requesteeId,
      'waiting': waiting,
      'viewed': viewed,
      'opened': opened,
      'timestamp': timestamp,
    };
  }
}

class CrewAcceptedNotification extends Notification {
  final String requesterId;
  final String requesteeId;
  final bool waiting;

  const CrewAcceptedNotification({
    required this.requesteeId,
    required this.requesterId,
    required this.waiting,
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
      'type': 'crew-accepted',
      'requesterId': requesterId,
      'requesteeId': requesteeId,
      'waiting': waiting,
      'viewed': viewed,
      'opened': opened,
      'timestamp': timestamp,
    };
  }
}

class SplitCrewsNotification extends Notification {
  final String requesterId;
  final String requesteeId;

  const SplitCrewsNotification({
    required this.requesteeId,
    required this.requesterId,
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
      'type': 'split-crew',
      'requesterId': requesterId,
      'requesteeId': requesteeId,
      'viewed': viewed,
      'opened': opened,
      'timestamp': timestamp,
    };
  }
}
