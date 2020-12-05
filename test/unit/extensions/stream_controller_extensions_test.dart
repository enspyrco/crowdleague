import 'dart:async';

import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/extensions/stream_controller_extensions.dart';
import 'package:crowdleague/models/problems/observe_processing_failures_problem.dart';
import 'package:crowdleague/utils/problem_utils.dart';
import 'package:test/test.dart';

void main() {
  group('StreamController', () {
    test('dispatches problems', () async {
      final controller = StreamController<ReduxAction>();

      dynamic error = 'ohno!';
      final trace = StackTrace.current;

      final testProblem = createProblem(
          ObserveProcessingFailuresProblem, error, trace, <String, Object>{});

      final expectedAction = AddProblem(problem: testProblem);

      controller.stream.listen(expectAsync1((action) {
        expect(action, equals(expectedAction));
      }, count: 1));

      controller.addProblem(
          ObserveProcessingFailuresProblem, error, trace, <String, Object>{});
    });
  });
}
