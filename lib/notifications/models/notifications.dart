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
      case 'follow-request':
        return FollowRequestNotification(
          id: json['id'] ?? '',
          viewed: json['viewed'] ?? false,
          opened: json['opened'] ?? false,
          waiting: json['waiting'] ?? false,
          requesterId: json['requesterId'],
          requesteeId: json['requesteeId'],
          timestamp: (json['timestamp'] as Timestamp).millisecondsSinceEpoch,
        );
      case 'follow-response':
        return FollowResponseNotification(
          id: json['id'] ?? '',
          viewed: json['viewed'] ?? false,
          opened: json['opened'] ?? false,
          requesteeId: json['requesteeId'],
          timestamp: (json['timestamp'] as Timestamp).millisecondsSinceEpoch,
        );
      case 'follow-back':
        return FollowBackNotification(
          id: json['id'] ?? '',
          viewed: json['viewed'] ?? false,
          opened: json['opened'] ?? false,
          waiting: json['waiting'] ?? false,
          requesterId: json['requesterId'],
          requesteeId: json['requesteeId'],
          timestamp: (json['timestamp'] as Timestamp).millisecondsSinceEpoch,
        );
      default:
        throw Exception('Unknown notification type');
    }
  }
}

class FollowRequestNotification extends Notification {
  final String requesterId;
  final String requesteeId;
  final bool waiting;

  const FollowRequestNotification({
    required this.requesteeId,
    required this.requesterId,
    required this.waiting,
    required super.id,
    required super.timestamp,
    required super.opened,
    required super.viewed,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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

class FollowBackNotification extends Notification {
  final String requesterId;
  final String requesteeId;
  final bool waiting;

  const FollowBackNotification({
    required this.requesteeId,
    required this.requesterId,
    required this.waiting,
    required super.id,
    required super.timestamp,
    required super.opened,
    required super.viewed,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': 'follow-back',
      'requesterId': requesterId,
      'requesteeId': requesteeId,
      'waiting': waiting,
      'viewed': viewed,
      'opened': opened,
      'timestamp': timestamp,
    };
  }
}

class FollowResponseNotification extends Notification {
  final String requesteeId;

  const FollowResponseNotification({
    required this.requesteeId,
    required super.id,
    required super.timestamp,
    required super.opened,
    required super.viewed,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': 'follow-response',
      'requesteeId': requesteeId,
      'viewed': viewed,
      'opened': opened,
      'timestamp': timestamp,
    };
  }
}
