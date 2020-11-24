import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:flutter/material.dart';

class ProblemAlert extends StatelessWidget {
  final ProblemBase problem;

  ProblemAlert({this.problem});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Dammit!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Looks like there was a problem.'),
            SizedBox(height: 20),
            Text(problem.message),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop<ProblemBase>(problem);
          },
        ),
      ],
    );
  }
}
