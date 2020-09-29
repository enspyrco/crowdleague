import 'package:crowdleague/actions/auth/sign_in_with_apple.dart';
import 'package:crowdleague/actions/auth/sign_in_with_google.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:crowdleague/widgets/auth/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

import '../../mocks/verify_dispatch_middleware.dart';

void main() {
  group('AuthPage', () {
    testWidgets('shows default UI while waiting for user input',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..authPage.step = AuthStep.waitingForInput);

      // Create the test harness.
      final store = Store<AppState>(appReducer, initialState: alteredState);
      final wut = AuthPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final defaultAuthPageUI = find.byType(PageContents);

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the default AuthPage UI is shown
      expect(defaultAuthPageUI, findsOneWidget);
    });

    testWidgets('displays without overflowing', (WidgetTester tester) async {
      // passing test indicates no overflowing as test suite uses a small device screen

      // Setup the app state with expected values
      final initialAppState = AppState.init();

      // Create the test harness.
      final store = Store<AppState>(appReducer, initialState: initialAppState);
      final wut = AuthPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final authPage = find.byType(AuthPage);

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that AuthPage is shown
      expect(authPage, findsOneWidget);
    });

    testWidgets('shows waiting indicator when signing in with google',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..authPage.step = AuthStep.signingInWithGoogle);

      // Create the test harness.
      final store = Store<AppState>(appReducer, initialState: alteredState);
      final wut = AuthPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Show google waiting indicator
      final waitingIndicator = find.byType(WaitingIndicator);
      expect(waitingIndicator, findsOneWidget);

      final googleWaitingIndicatorText = find.text('Contacting Google...');
      expect(googleWaitingIndicatorText, findsOneWidget);
    });

    testWidgets('shows waiting indicator when signing in with apple',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..authPage.step = AuthStep.signingInWithApple);

      // Create the test harness.
      final store = Store<AppState>(appReducer, initialState: alteredState);
      final wut = AuthPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Show apple waiting indicator
      final waitingIndicator = find.byType(WaitingIndicator);
      expect(waitingIndicator, findsOneWidget);

      // check that correct waiting text is shown
      final appleWaitingIndicatorText = find.text('Contacting Apple...');
      expect(appleWaitingIndicatorText, findsOneWidget);
    });

    testWidgets('shows waiting indicator when signing in with firebase',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..authPage.step = AuthStep.signingInWithFirebase);

      // Create the test harness.
      final store = Store<AppState>(appReducer, initialState: alteredState);
      final wut = AuthPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Show waiting indicator
      final waitingIndicator = find.byType(WaitingIndicator);
      expect(waitingIndicator, findsOneWidget);

      // check that correct waiting text is shown
      final firebaseWaitingIndicatorText =
          find.text('Signing in with Firebase...');
      expect(firebaseWaitingIndicatorText, findsOneWidget);
    });

    testWidgets('shows "Sign In with Google" button on Android',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..systemInfo.platform = PlatformType.android);
      // Create the test harness.
      final store = Store<AppState>(appReducer, initialState: alteredState);
      final wut = AuthPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final googleSignInButton = find.byType(GoogleSignInButton);

      // dispatch action to set platform to android
      expect(googleSignInButton, findsOneWidget);
    });

    testWidgets('shows "Sign In with Apple" button on iOS',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..systemInfo.platform = PlatformType.ios);

      // Create the test harness.
      final store = Store<AppState>(appReducer, initialState: alteredState);
      final wut = AuthPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final appleSignInButton = find.byType(AppleSignInButton);

      // dispatch action to set platform to android
      expect(appleSignInButton, findsOneWidget);
    });

    testWidgets('dispatches SignInWithApple action on iOS',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..systemInfo.platform = PlatformType.ios);
      final testMiddleware = VerifyDispatchMiddleware();

      // Create the test harness.
      final store = Store<AppState>(appReducer,
          initialState: alteredState, middleware: [testMiddleware]);
      final wut = AuthPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final platformSignIn = find.byType(PlatformSignInButton);
      expect(platformSignIn, findsOneWidget);

      // Tap to sign in
      await tester.tap(platformSignIn);

      // check correct action is dispatched
      expect(testMiddleware.received(SignInWithApple()), true);
    });
    testWidgets('dispatches SignInWithGoogle action on Android',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..systemInfo.platform = PlatformType.android);
      final testMiddleware = VerifyDispatchMiddleware();

      // Create the test harness.
      final store = Store<AppState>(appReducer,
          initialState: alteredState, middleware: [testMiddleware]);
      final wut = AuthPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final platformSignIn = find.byType(PlatformSignInButton);
      expect(platformSignIn, findsOneWidget);

      // Tap to sign in
      await tester.tap(platformSignIn);

      // check correct action is dispatched
      expect(testMiddleware.received(SignInWithGoogle()), true);
    });
  });
}
