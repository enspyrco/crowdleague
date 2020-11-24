import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/extensions/stream_controller_extensions.dart';
import 'package:crowdleague/models/problems/observe_processing_failures_problem.dart';
import 'package:test/test.dart';

void main() {
  group('StreamController', () {
    test('dispatches problems', () async {
      final controller = StreamController<ReduxAction>();

      dynamic error = 'ohno!';
      final trace = StackTrace.current;
      final info = MapBuilder<String, Object>();

      final testProblem = ObserveProcessingFailuresProblem.by(
        (b) => b
          ..message = error.toString()
          ..trace = trace.toString()
          ..info = info,
      );

      final expectedAction = AddProblem(problem: testProblem);

      controller.stream.listen(expectAsync1((action) {
        expect(action, equals(expectedAction));
      }, count: 1));

      controller.addProblem(
          ObserveProcessingFailuresProblem, error, trace, info);
    });
  });
}
