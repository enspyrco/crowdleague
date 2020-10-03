import 'package:crowdleague/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../mocks/navigation/global_key_mocks.dart';
import '../../mocks/navigation/navigator_state_mocks.dart';
import '../../mocks/navigation/route_mocks.dart';

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
      final mockNavigatorState = MockNavigatorState();
      final fakeNavKey = FakeGlobalKey(mockNavigatorState);
      final service = NavigationService(fakeNavKey);

      /// The service calls [popUntil(ModalRoute.withName('/'))]
      /// [ModalRoute.withName('/')] returns a predicate that checks for the
      /// following:
      /// [!route.willHandlePopInternally]
      /// [route is ModalRoute]
      /// [route.settings.name == name']

      /// Our stub just returns the values needed for the [withName()] predicate
      final modalRouteStub =
          ModalRouteStub<dynamic>(settings: RouteSettings(name: '/'));

      // perform the action we are testing
      service.popHome();

      /// verify that [popUntil()] was called with a predicate matching the stub
      verify(mockNavigatorState.popUntil(argThat(predicate<RoutePredicate>(
          (func) => func(modalRouteStub) == true,
          'is a route predicate for \'/\''))));
    });

    test('replaceCurrentWith calls NavigatorState.pushReplacementNamed', () {
      final navigatorState = MockNavigatorState();
      final fakeNavKey = FakeGlobalKey(navigatorState);
      final service = NavigationService(fakeNavKey);

      service.replaceCurrentWith('location');

      verify(navigatorState.pushReplacementNamed('location'));
    });
  });
}
