import 'package:crowdleague/actions/auth/sign_in_with_apple.dart';
import 'package:crowdleague/actions/auth/sign_in_with_google.dart';
import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:crowdleague/widgets/auth/other_auth_options_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

import '../../utils/verify_dispatch_middleware.dart';

void main() {
  group('OtherAuthOptionsPage', () {
    testWidgets('shows "Sign In with Apple" button on Android',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..systemInfo.platform = PlatformType.android);
      // Create the test harness.
      final store = Store<AppState>(appReducer, initialState: alteredState);
      final wut = OtherAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final appleSignInButton = find.byType(AppleSignInButton);

      // dispatch action to set platform to android
      expect(appleSignInButton, findsOneWidget);
    });

    testWidgets('shows "Sign In with Google" button on iOS',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..systemInfo.platform = PlatformType.ios);

      // Create the test harness.
      final store = Store<AppState>(appReducer, initialState: alteredState);
      final wut = OtherAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final googleSignInButton = find.byType(GoogleSignInButton);

      // dispatch action to set platform to android
      expect(googleSignInButton, findsOneWidget);
    });

    testWidgets('dispatches SignInWithGoogle action on iOS',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..systemInfo.platform = PlatformType.ios);
      final testMiddleware = VerifyDispatchMiddleware();

      // Create the test harness.
      final store = Store<AppState>(appReducer,
          initialState: alteredState, middleware: [testMiddleware]);
      final wut = OtherAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final otherPlatFormSignInButton = find.byType(OtherPlatformSignInButton);
      expect(otherPlatFormSignInButton, findsOneWidget);

      // Tap to sign in
      await tester.tap(otherPlatFormSignInButton);

      // check correct action is dispatched
      expect(testMiddleware.received(SignInWithGoogle()), true);
    });

    testWidgets('dispatches SignInWithApple action on Android',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..systemInfo.platform = PlatformType.android);
      final testMiddleware = VerifyDispatchMiddleware();

      // Create the test harness.
      final store = Store<AppState>(appReducer,
          initialState: alteredState, middleware: [testMiddleware]);
      final wut = OtherAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final otherPlatFormSignInButton = find.byType(OtherPlatformSignInButton);
      expect(otherPlatFormSignInButton, findsOneWidget);

      // Tap to sign in
      await tester.tap(otherPlatFormSignInButton);

      // check correct action is dispatched
      expect(testMiddleware.received(SignInWithApple()), true);
    });
  });
}
