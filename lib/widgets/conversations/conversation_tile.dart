import 'package:crowdleague/models/conversations/conversation_item.dart';
import 'package:flutter/material.dart';

class ConversationTile extends StatelessWidget {
  final ConversationItem item;

  ConversationTile({@required this.item, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(item.photoUrls.first),
      title: Text(item.displayNames.first),
    );
  }
}
