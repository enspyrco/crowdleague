import 'package:crowdleague/actions/conversations/store_selected_conversation.dart';
import 'package:crowdleague/actions/navigation/navigate_to.dart';
import 'package:crowdleague/models/conversations/conversation_item.dart';
import 'package:flutter/material.dart';

import 'package:crowdleague/extensions/extensions.dart';

class ConversationItemTile extends StatelessWidget {
  final ConversationItem item;

  ConversationItemTile({@required this.item, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(item.photoURLs.first),
      title: Text(item.displayNames.first),
      onTap: () {
        context
            .dispatch(StoreSelectedConversation((b) => b..item.replace(item)));
        context.dispatch(NavigateTo((b) => b..location = '/conversation'));
      },
    );
  }
}
