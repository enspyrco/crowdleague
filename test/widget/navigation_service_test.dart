import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/models/app/problem.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/navigation/global_key_mocks.dart';
import '../mocks/navigation/navigator_state_mocks.dart';

void main() {
  group('NavigationService', () {
    testWidgets('display uses NavigatorState.overlay.context',
        (WidgetTester tester) async {
      final navigatorState = MockNavigatorState();
      final fakeNavKey = FakeGlobalKey(navigatorState);
      final service = NavigationService(fakeNavKey);

      await service.display(Problem(
          message: 'message', info: BuiltMap(), type: ProblemType.appleSignIn));

      verify(navigatorState.overlay);
    });

    testWidgets('displayConfirmation calls NavigatorState.pushNamed',
        (WidgetTester tester) async {});
  });
}
