import 'package:crowdleague/models/actions/navigation/add_problem.dart';
import 'package:crowdleague/models/enums/problem_type.dart';
import 'package:crowdleague/models/navigation/problem.dart';

extension AddProblemFuture on AddProblem {
  static Future<AddProblem> from(
      dynamic error, StackTrace trace, ProblemType type) {
    return Future.value(AddProblem(
      (b) => b
        ..problem.replace(Problem((b) => b
          ..message = error.toString()
          ..trace = trace.toString()
          ..type = type)),
    ));
  }
}

extension AddProblemObject on AddProblem {
  static AddProblem from(dynamic error, StackTrace trace, ProblemType type) {
    return AddProblem(
      (b) => b
        ..problem.replace(Problem((b) => b
          ..message = error.toString()
          ..trace = trace.toString()
          ..type = type)),
    );
  }
}
