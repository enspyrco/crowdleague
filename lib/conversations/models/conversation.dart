class Conversation {
  Conversation({
    required this.id,
    required this.participantIds,
  });

  final String id;
  final List<String> participantIds;

  factory Conversation.fromJsonWithId(String id, Map<String, dynamic> json) {
    return Conversation(
      id: id,
      participantIds: List<String>.from(json['participantIds'] as List),
    );
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      participantIds: List<String>.from(json['participantIds'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participantIds': participantIds,
    };
  }
}
