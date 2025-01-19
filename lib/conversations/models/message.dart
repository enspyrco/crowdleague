import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    required this.id,
    required this.value,
    required this.senderId,
    required this.timestamp,
    required this.readBy,
  });

  final String id;
  final String value;
  final String senderId;
  final int timestamp;
  final List<String> readBy;

  factory Message.fromJsonWithId(String id, Map<String, dynamic> json) {
    return Message(
      id: id,
      value: json['value'] as String,
      senderId: json['senderId'] as String,
      timestamp: (json['timestamp'] as Timestamp).millisecondsSinceEpoch,
      readBy: List<String>.from(json['readBy'] as List),
    );
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      value: json['value'] as String,
      senderId: json['senderId'] as String,
      timestamp: (json['timestamp'] as Timestamp).millisecondsSinceEpoch,
      readBy: List<String>.from(json['readBy'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'senderId': senderId,
      'timestamp': timestamp,
      'readBy': readBy,
    };
  }
}
