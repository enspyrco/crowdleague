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
