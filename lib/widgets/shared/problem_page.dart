import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:flutter/material.dart';

/// Creates a widget to show a message from a type of [ProblemBase].
/// The ProblemPage is used for alerting a user to an error.
class ProblemPage extends StatelessWidget {
  final ProblemBase problem;

  const ProblemPage({Key key, @required this.problem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Whoops'),
      content: SingleChildScrollView(
        child: Text(problem.message),
      ),
    );
  }
}
