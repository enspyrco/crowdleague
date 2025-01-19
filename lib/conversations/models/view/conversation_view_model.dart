import 'dart:typed_data';

import '../conversation.dart';

class ConversationViewModel {
  ConversationViewModel({
    required this.conversation,
    required this.lastMessagePicData,
    required this.lastMessageName,
    required this.identifyingLastMessageValue,
  });

  final Conversation conversation;
  final String identifyingLastMessageValue;
  final String lastMessageName;
  final Uint8List lastMessagePicData;

  factory ConversationViewModel.fromJson(Map<String, dynamic> json) {
    return ConversationViewModel(
      identifyingLastMessageValue:
          json['identifyingLastMessageValue'] as String,
      conversation: Conversation.fromJson(json['conversation']),
      lastMessagePicData: Uint8List.fromList(List<int>.from(json['iconData'])),
      lastMessageName: json['lastMessageName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation': conversation.toJson(),
      'iconData': lastMessagePicData.toList(),
    };
  }
}
