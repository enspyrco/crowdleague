import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/conversations/conversation/message.dart';
import 'package:crowdleague/widgets/conversations/messages_page/message_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MessagesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BuiltList<Message>>(
      distinct: true,
      converter: (store) => store.state.messagesPage.messages,
      builder: (context, messages) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return MessageTile(message: messages[index]);
            });
      },
    );
  }
}
