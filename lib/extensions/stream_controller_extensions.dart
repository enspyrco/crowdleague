import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/problems/observe_processing_failures_problem.dart';
import 'package:crowdleague/models/problems/problem_base.dart';

extension StreamControllerExt on StreamController<ReduxAction> {
  static final Map<Type,
          ProblemBase Function(dynamic, StackTrace, MapBuilder<String, Object>)>
      _problemMap = {
    ObserveProcessingFailuresProblem: (dynamic error, trace, info) =>
        ObserveProcessingFailuresProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
  };

  void addProblem(dynamic error, StackTrace trace,
          MapBuilder<String, Object> info, Type type) =>
      add(AddProblem(problem: _problemMap[type](error, trace, info)));
}
