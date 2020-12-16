import 'package:flutter/material.dart';

class ProblemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Whoops'),
      content: SingleChildScrollView(
        child: Text('This is where the problem message goes'),
      ),
    );
  }
}
