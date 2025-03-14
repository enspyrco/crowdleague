import '../conversation.dart';

/// A ConversationViewModel carries the original Conversation along with the
/// objects required to display the Conversation item.
class ConversationViewModel {
  ConversationViewModel({
    required this.conversation,
    required this.lastMessagePlayerId,
    required this.lastMessagePlayerName,
    required this.lastMessageText,
  });

  final Conversation conversation;
  final String lastMessagePlayerId;
  final String lastMessageText;
  final String lastMessagePlayerName;

  factory ConversationViewModel.fromJson(Map<String, dynamic> json) {
    return ConversationViewModel(
      conversation: Conversation.fromJson(json['conversation']),
      lastMessagePlayerId: json['lastMessagePlayerId'] as String,
      lastMessagePlayerName: json['lastMessagePlayerName'] as String,
      lastMessageText: json['lastMessageText'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation': conversation.toJson(),
      'lastMessagePlayerId': lastMessagePlayerId,
    };
  }
}
