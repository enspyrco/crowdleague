import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/models/app/problem.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../mocks/navigation/global_key_mocks.dart';
import '../../mocks/navigation/navigator_state_mocks.dart';

/// The NavigationService unit tests

void main() {
  group('Navigation Service.', () {
    // has a method that returns a stream that emits user

    test('navigateTo calls NavigatorState.pushNamed', () {
      // the navKey is created in main, passed to the navigation service as
      // well as into the CrowdLeagueApp widget where it is used by the
      // MaterialApp widget as the navigatorKey member.

      // The NavigatorService uses the GlobalKey's NavigatorState
      // to perform navigation.

      // Here we create a fake GlobalKey that just returns a mocked
      // NavigatorState, then verify that the NavigatorService uses
      // the NavigatorState to make the expected call.

      final navigatorState = MockNavigatorState();
      final fakeNavKey = FakeGlobalKey(navigatorState);
      final service = NavigationService(fakeNavKey);

      service.navigateTo('location');

      verify(navigatorState.pushNamed('location'));
    });

    test('popHome calls NavigatorState.popUntil with /', () {
      final navigatorState = MockNavigatorState();
      final fakeNavKey = FakeGlobalKey(navigatorState);
      final service = NavigationService(fakeNavKey);

      service.popHome();

      verify(navigatorState.popUntil(ModalRoute.withName('/')));
    },
        skip:
            'fails with "No matching calls" - maybe because ModalRoute.withName is a different object to the original call?');

    test('replaceCurrentWith calls NavigatorState.pushReplacementNamed', () {
      final navigatorState = MockNavigatorState();
      final fakeNavKey = FakeGlobalKey(navigatorState);
      final service = NavigationService(fakeNavKey);

      service.replaceCurrentWith('location');

      verify(navigatorState.pushReplacementNamed('location'));
    });

    // Fails assertion: 'context != null': is not true.
    // This probably should be tested in a widget test where
    // we can get a context
    test('display uses NavigatorState.overlay.context', () {
      final navigatorState = MockNavigatorState();
      final fakeNavKey = FakeGlobalKey(navigatorState);
      final service = NavigationService(fakeNavKey);

      service.display(Problem((b) => b
        ..message = 'message'
        ..type = ProblemType.appleSignIn));

      verify(navigatorState.overlay);
    }, skip: 'probably needs to be a widget test');

    test('displayConfirmation calls NavigatorState.pushNamed', () {},
        skip: 'same problem as testing display');
  });
}
