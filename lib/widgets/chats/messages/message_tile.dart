import 'package:crowdleague/models/conversations/conversation/message.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final Message message;

  MessageTile({@required this.message, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(message.text),
    );
  }
}
