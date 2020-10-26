import 'package:flutter/material.dart';

class ExplanationText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'CROWDLEAGUE',
          style: TextStyle(fontSize: 40),
        ),
        SizedBox(height: 20),
        Text(
          'A PLATFORM',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'FOR CROWD SOURCING',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'SPORTS LEAGUES',
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
