import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/conversations/conversation_item.dart';
import 'package:crowdleague/widgets/conversations/conversations_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ConversationItemsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BuiltList<ConversationItem>>(
      distinct: true,
      converter: (store) => store.state.conversationItemsPage.items,
      builder: (context, vm) {
        return ConversationsList(
          items: vm,
        );
      },
    );
  }
}
