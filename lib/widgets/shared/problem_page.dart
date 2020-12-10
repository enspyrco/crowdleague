import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:flutter/material.dart';

class ProblemPage extends StatelessWidget {
  final ProblemBase problem;

  ProblemPage(this.problem);

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
