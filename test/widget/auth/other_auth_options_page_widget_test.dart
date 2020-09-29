import 'package:crowdleague/actions/auth/sign_up_with_email.dart';
import 'package:crowdleague/actions/auth/update_other_auth_options_page.dart';
import 'package:crowdleague/enums/email_auth_mode.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:crowdleague/widgets/auth/other_auth_options_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

import '../../mocks/verify_dispatch_middleware.dart';

void main() {
  group('OtherAuthOptionsPage', () {
    testWidgets('displays without overflowing', (WidgetTester tester) async {
      // passing test indicates no overflowing as test suite uses a small device screen

      // Setup the app state with expected values
      final initialAppState = AppState.init();

      // Create the test harness.
      final store = Store<AppState>(appReducer, initialState: initialAppState);
      final wut = OtherAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final otherAuthOptionsPage = find.byType(OtherAuthOptionsPage);

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that OtherAuthOptionsPage is shown
      expect(otherAuthOptionsPage, findsOneWidget);
    });
    testWidgets(
        'dispatches UpdateOtherAuthOptionsPage(EmailAuthMode.signUp) action when tap sign in with email chip',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final testMiddleware = VerifyDispatchMiddleware();

      // Create the test harness.
      final store = Store<AppState>(appReducer,
          initialState: initialAppState, middleware: [testMiddleware]);
      final wut = OtherAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final emailSignUpChip = find.byType(EmailSignUpChip);
      expect(emailSignUpChip, findsOneWidget);

      // Tap to show create account button
      await tester.tap(emailSignUpChip);

      // check correct action is dispatched
      expect(
          testMiddleware
              .received(UpdateOtherAuthOptionsPage(mode: EmailAuthMode.signUp)),
          true);
    });
    testWidgets(
        'dispatches UpdateOtherAuthOptionsPage(EmailAuthMode.signIn) action when tap create an account chip',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final testMiddleware = VerifyDispatchMiddleware();

      // Create the test harness.
      final store = Store<AppState>(appReducer,
          initialState: initialAppState, middleware: [testMiddleware]);
      final wut = OtherAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final emailSigninChip = find.byType(EmailSignInChip);
      expect(emailSigninChip, findsOneWidget);

      // Tap to show create account button
      await tester.tap(emailSigninChip);

      // check correct action is dispatched
      expect(
          testMiddleware
              .received(UpdateOtherAuthOptionsPage(mode: EmailAuthMode.signIn)),
          true);
    });
    testWidgets('sign in button dispatches SignInWithEmail action',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final testMiddleware = VerifyDispatchMiddleware();

      // Create the test harness.
      final store = Store<AppState>(appReducer,
          initialState: initialAppState, middleware: [testMiddleware]);
      final wut = OtherAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final signInButton = find.byType(SignInButton);
      expect(signInButton, findsOneWidget);

      // Tap to show create account button
      await tester.tap(signInButton);

      // check correct action is dispatched
      expect(testMiddleware.received(SignUpWithEmail()), true);
    });
    testWidgets('create account button dispatches SignUpWithEmail action',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final testMiddleware = VerifyDispatchMiddleware();

      // Create the test harness.
      final store = Store<AppState>(appReducer,
          initialState: initialAppState, middleware: [testMiddleware]);
      final wut = OtherAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final createAccountButton = find.byType(CreateAccountButton);
      expect(createAccountButton, findsOneWidget);

      // Tap to show create account button
      await tester.tap(createAccountButton);

      // check correct action is dispatched
      expect(testMiddleware.received(SignUpWithEmail()), true);
    });
  });
}
