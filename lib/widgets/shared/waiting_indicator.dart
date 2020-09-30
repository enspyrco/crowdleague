import 'package:flutter/material.dart';

class WaitingIndicator extends StatelessWidget {
  final String message;
  const WaitingIndicator(
    this.message, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[CircularProgressIndicator(), Text(message)]);
  }
}
