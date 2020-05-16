import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/conversations/conversation_summary.dart';
import 'package:crowdleague/widgets/conversations/conversation_summaries/conversation_summaries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ConversationSummariesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BuiltList<ConversationSummary>>(
      distinct: true,
      converter: (store) => store.state.conversationSummariesPage.summaries,
      builder: (context, summaries) {
        return ConversationSummariesList(
          summaries: summaries,
        );
      },
    );
  }
}
