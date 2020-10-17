import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/models/conversations/conversation_summary.dart';
import 'package:crowdleague/widgets/conversations/conversation_summaries_page/conversation_summary_tile.dart';
import 'package:flutter/material.dart';

class ConversationSummariesList extends StatelessWidget {
  final BuiltList<ConversationSummary> summaries;

  ConversationSummariesList({@required this.summaries, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: summaries.length,
        itemBuilder: (context, index) =>
            ConversationSummaryTile(summary: summaries[index]));
  }
}
