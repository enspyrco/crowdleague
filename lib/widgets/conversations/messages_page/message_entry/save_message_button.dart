import 'package:crowdleague/actions/conversations/save_message.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:flutter/material.dart';

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
