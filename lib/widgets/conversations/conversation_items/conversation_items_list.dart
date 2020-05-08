import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/models/conversations/conversation_item.dart';
import 'package:crowdleague/widgets/conversations/conversation_items/conversation_item_tile.dart';
import 'package:flutter/material.dart';

class ConversationItemsList extends StatelessWidget {
  final BuiltList<ConversationItem> items;

  ConversationItemsList({@required this.items, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) =>
            ConversationItemTile(item: items[index]));
  }
}
