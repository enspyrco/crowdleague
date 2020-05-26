import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/models/conversations/conversation_summary.dart';
import 'package:crowdleague/widgets/chats/conversations/conversation_tile.dart';
import 'package:flutter/material.dart';

class ConversationsList extends StatelessWidget {
  final BuiltList<ConversationSummary> summaries;

  ConversationsList({@required this.summaries, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: summaries.length,
        itemBuilder: (context, index) =>
            ConversationTile(summary: summaries[index]));
  }
}
