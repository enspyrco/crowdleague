import 'package:flutter/material.dart';

class TaglineText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'BE IN A LEAGUE',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'OF YOUR OWN',
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
