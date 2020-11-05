import 'package:crowdleague/actions/conversations/update_messages_page.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:flutter/material.dart';

class MessageTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 8, bottom: 25),
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Message',
          ),
          onChanged: (value) =>
              context.dispatch(UpdateMessagesPage(messageText: value)),
        ),
      ),
    );
  }
}
