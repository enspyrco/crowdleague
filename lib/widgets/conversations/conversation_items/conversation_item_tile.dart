import 'package:crowdleague/models/conversations/conversation_item.dart';
import 'package:flutter/material.dart';

class ConversationItemTile extends StatelessWidget {
  final ConversationItem item;

  ConversationItemTile({@required this.item, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(item.photoURLs.first),
      title: Text(item.displayNames.first),
    );
  }
}
