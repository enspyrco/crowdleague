import 'dart:async';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/utils/problem_utils.dart';

extension StreamControllerExt on StreamController<ReduxAction> {
  void addProblem(Type type, dynamic error, StackTrace trace,
          [Map<String, Object> info]) =>
      add(createAddProblem(type, error, trace, info));
}
