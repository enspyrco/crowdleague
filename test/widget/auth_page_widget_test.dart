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

void main() {
  group('AuthPage', () {
    testWidgets('show default AuthPage ui while waiting for user input',
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
    group('provider sign in buttons', () {
      testWidgets('shows GoogleSignInButton on Android',
          (WidgetTester tester) async {
        // Setup the app state with expected values
        final initialAppState = AppState.init();
        final alteredState =
            initialAppState.rebuild((b) => b..platform = PlatformType.android);
        // Create the test harness.
        final store = Store<AppState>(appReducer, initialState: alteredState);
        final wut = AuthPage();
        final harness = StoreProvider<AppState>(
            store: store, child: MaterialApp(home: wut));

        // Tell the tester to build the widget tree.
        await tester.pumpWidget(harness);

        // Create the Finders.
        final googleSignInButton = find.byType(GoogleSignInButton);

        // dispatch action to set platform to android
        expect(googleSignInButton, findsOneWidget);
      });
      testWidgets('shows AppleSignInButton on IOS',
          (WidgetTester tester) async {
        // Setup the app state with expected values
        final initialAppState = AppState.init();
        final alteredState =
            initialAppState.rebuild((b) => b..platform = PlatformType.ios);
        // Create the test harness.
        final store = Store<AppState>(appReducer, initialState: alteredState);
        final wut = AuthPage();
        final harness = StoreProvider<AppState>(
            store: store, child: MaterialApp(home: wut));

        // Tell the tester to build the widget tree.
        await tester.pumpWidget(harness);

        // Create the Finders.
        final appleSignInButton = find.byType(AppleSignInButton);

        // dispatch action to set platform to android
        expect(appleSignInButton, findsOneWidget);
      });
    });

    group('on platform default sign in', () {
      // TODO: waiting for VerifyDispatchMiddleware to verify action calls
      testWidgets('on IOS device, dispatches signInWithApple action',
          (WidgetTester tester) async {
        // Setup the app state with expected values
        final initialAppState = AppState.init();
        final alteredState =
            initialAppState.rebuild((b) => b..platform = PlatformType.ios);
        // Create the test harness.
        final store = Store<AppState>(appReducer, initialState: alteredState);
        final wut = AuthPage();
        final harness = StoreProvider<AppState>(
            store: store, child: MaterialApp(home: wut));

        // Tell the tester to build the widget tree.
        await tester.pumpWidget(harness);

        // Create the Finders.
        final platformSignIn = find.byType(PlatformSignInButton);
        expect(platformSignIn, findsOneWidget);

        // Tap to sign in
        await tester.tap(platformSignIn);

        // check correct action is dispatched
        // use VerifyDispatchMiddleware to verfiy action call
      });
      // TODO: waiting for VerifyDispatchMiddleware to verify action calls
      testWidgets('on Android device, dispatches signInWithGoogle action',
          (WidgetTester tester) async {
        // Setup the app state with expected values
        final initialAppState = AppState.init();
        final alteredState =
            initialAppState.rebuild((b) => b..platform = PlatformType.android);
        // Create the test harness.
        final store = Store<AppState>(appReducer, initialState: alteredState);
        final wut = AuthPage();
        final harness = StoreProvider<AppState>(
            store: store, child: MaterialApp(home: wut));

        // Tell the tester to build the widget tree.
        await tester.pumpWidget(harness);

        // Create the Finders.
        final platformSignIn = find.byType(PlatformSignInButton);
        expect(platformSignIn, findsOneWidget);

        // Tap to sign in
        await tester.tap(platformSignIn);

        // check correct action is dispatched
        // use VerifyDispatchMiddleware to verfiy action call
      });
      testWidgets(
          'shows correct waiting indicator when signing in on Android device',
          (WidgetTester tester) async {
        // Setup the app state with expected values
        final initialAppState = AppState.init();
        final alteredState = initialAppState
            .rebuild((b) => b..authPage.step = AuthStep.signingInWithGoogle);
        // Create the test harness.
        final store = Store<AppState>(appReducer, initialState: alteredState);
        final wut = AuthPage();
        final harness = StoreProvider<AppState>(
            store: store, child: MaterialApp(home: wut));

        // Tell the tester to build the widget tree.
        await tester.pumpWidget(harness);

        // Show android waiting indicator
        final waitingIndicator = find.byType(WaitingIndicator);
        expect(waitingIndicator, findsOneWidget);

        final androidWaitingIndicatorText = find.text('Contacting Google...');
        expect(androidWaitingIndicatorText, findsOneWidget);
      });
      testWidgets(
          'shows correct waiting indicator when signing in on MacOs device',
          (WidgetTester tester) async {
        // Setup the app state with expected values
        final initialAppState = AppState.init();
        final alteredState = initialAppState
            .rebuild((b) => b..authPage.step = AuthStep.signingInWithApple);
        // Create the test harness.
        final store = Store<AppState>(appReducer, initialState: alteredState);
        final wut = AuthPage();
        final harness = StoreProvider<AppState>(
            store: store, child: MaterialApp(home: wut));

        // Tell the tester to build the widget tree.
        await tester.pumpWidget(harness);

        // Show android waiting indicator
        final waitingIndicator = find.byType(WaitingIndicator);
        expect(waitingIndicator, findsOneWidget);

        final androidWaitingIndicatorText = find.text('Contacting Apple...');
        expect(androidWaitingIndicatorText, findsOneWidget);
      });
    });
  });
}
