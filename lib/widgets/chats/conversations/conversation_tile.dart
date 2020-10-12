import 'package:crowdleague/actions/conversations/leave_conversation.dart';
import 'package:crowdleague/actions/conversations/store_selected_conversation.dart';
import 'package:crowdleague/actions/navigation/push_page.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/conversations/conversation_summary.dart';
import 'package:crowdleague/models/navigation/page_data/messages_page_data.dart';
import 'package:flutter/material.dart';

class ConversationTile extends StatelessWidget {
  final ConversationSummary summary;

  ConversationTile({@required this.summary, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // Show a red background as the item is swiped away.
      background: Container(color: Colors.red),
      key: Key(summary.conversationId),
      onDismissed: (direction) {
        context.dispatch(
            LeaveConversation(conversationId: summary.conversationId));

        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
                'Leaving conversation with id: ${summary.conversationId}')));
      },
      child: ListTile(
        leading: Image.network(summary.photoURLs.first),
        title: Text(summary.displayNames.first),
        onTap: () {
          context.dispatch(StoreSelectedConversation(summary: summary));
          context.dispatch(PushPage(data: MessagesPageData()));
        },
      ),
    );
  }
}
