import 'package:cloud_firestore/cloud_firestore.dart';

sealed class Notification {
  const Notification({
    required this.viewed,
    required this.opened,
    required this.timestamp,
    required this.id,
  });
  final String id;
  final bool viewed;
  final bool opened;
  final int timestamp;

  factory Notification.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'team-up-request':
        return TeamUpRequestNotification(
          id: json['id'] ?? '',
          viewed: json['viewed'] ?? false,
          opened: json['opened'] ?? false,
          requesterId: json['requesterId'],
          timestamp: (json['timestamp'] as Timestamp).millisecondsSinceEpoch,
        );
      case 'team-up-response':
        return TeamUpResponseNotification(
          id: json['id'] ?? '',
          viewed: json['viewed'] ?? false,
          opened: json['opened'] ?? false,
          requesteeId: json['requesteeId'],
          timestamp: json['timestamp'],
        );
      default:
        throw Exception('Unknown notification type');
    }
  }
}

class TeamUpRequestNotification extends Notification {
  final String requesterId;

  const TeamUpRequestNotification({
    required this.requesterId,
    required super.id,
    required super.timestamp,
    required super.opened,
    required super.viewed,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': 'team-up-request',
      'requesterId': requesterId,
      'viewed': viewed,
      'opened': opened,
      'timestamp': timestamp,
    };
  }
}

class TeamUpResponseNotification extends Notification {
  final String requesteeId;

  const TeamUpResponseNotification({
    required this.requesteeId,
    required super.id,
    required super.timestamp,
    required super.opened,
    required super.viewed,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': 'team-up-response',
      'requesteeId': requesteeId,
      'viewed': viewed,
      'opened': opened,
      'timestamp': timestamp,
    };
  }
}
