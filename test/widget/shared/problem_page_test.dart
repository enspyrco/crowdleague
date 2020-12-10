import 'package:crowdleague/models/problems/general_problem.dart';
import 'package:crowdleague/utils/problem_utils.dart';
import 'package:crowdleague/widgets/shared/problem_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/widget_test_harness.dart';

void main() {
  group('ProblemPage', () {
    testWidgets('shows expected message', (WidgetTester tester) async {
      // Create a problem
      final problem = createProblem(
          GeneralProblem, 'Problem error message', StackTrace.current);

      // Setup a test harness.
      final harness = WidgetTestHarness(widgetUnderTest: ProblemPage(problem));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness.widget);

      // Create the Finders.
      final problemMessageText = find.text(problem.message);

      // verify that the AuthPage UI is shown
      expect(problemMessageText, findsOneWidget);
    });
  });
}
