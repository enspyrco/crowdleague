import 'package:crowdleague/actions/conversations/save_message.dart';
import 'package:crowdleague/actions/conversations/update_conversation_page.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:flutter/material.dart';

class MessageEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MessageTextField(),
        SaveMessageButton(),
      ],
    );
  }
}

class SaveMessageButton extends StatelessWidget {
  const SaveMessageButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: IconButton(
          icon: Icon(Icons.send),
          onPressed: () => context.dispatch(SaveMessage())),
    );
  }
}

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
              context.dispatch(UpdateConversationPage(messageText: value)),
        ),
      ),
    );
  }
}
