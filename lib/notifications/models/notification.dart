sealed class Notification {
  const Notification(
      {this.viewed = false, this.opened = false, required this.timestamp});
  final bool viewed;
  final bool opened;
  final int timestamp;

  factory Notification.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'team-up-request':
        return TeamUpRequestNotification(
          requesterId: json['requesterId'],
          timestamp: json['timestamp'],
        );
      case 'team-up-response':
        return TeamUpResponseNotification(
          requestedId: json['requestedId'],
          timestamp: json['timestamp'],
        );
      default:
        throw Exception('Unknown notification type');
    }
  }
}

class TeamUpRequestNotification extends Notification {
  final String requesterId;

  const TeamUpRequestNotification(
      {required this.requesterId, required super.timestamp});

  Map<String, dynamic> toJson() {
    return {
      'type': 'team-up-request',
      'requesterId': requesterId,
      'viewed': viewed,
      'opened': opened,
      'timestamp': timestamp,
    };
  }
}

class TeamUpResponseNotification extends Notification {
  final String requestedId;

  const TeamUpResponseNotification(
      {required this.requestedId, required super.timestamp});

  Map<String, dynamic> toJson() {
    return {
      'type': 'team-up-response',
      'requestedId': requestedId,
      'viewed': viewed,
      'opened': opened,
      'timestamp': timestamp,
    };
  }
}
