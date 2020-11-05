import 'package:crowdleague/widgets/conversations/messages_page/message_entry/message_text_field.dart';
import 'package:crowdleague/widgets/conversations/messages_page/message_entry/save_message_button.dart';
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
