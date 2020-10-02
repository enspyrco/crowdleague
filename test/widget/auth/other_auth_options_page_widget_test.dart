import 'package:crowdleague/actions/auth/sign_in_with_apple.dart';
import 'package:crowdleague/actions/auth/sign_in_with_email.dart';
import 'package:crowdleague/actions/auth/sign_in_with_google.dart';
import 'package:crowdleague/actions/auth/sign_up_with_email.dart';
import 'package:crowdleague/actions/auth/update_other_auth_options_page.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:crowdleague/enums/email_auth_mode.dart';
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

    testWidgets(
        'shows sign in UI when user lands on page, and after user taps sign in chip',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..otherAuthOptionsPage.mode = EmailAuthMode.signIn);

      // Create the test harness.
      final store = Store<AppState>(appReducer, initialState: alteredState);
      final wut = OtherAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders for create account UI
      final repeatPasswordTextField = find.byType(RepeatPasswordTextField);
      final createAccountButton = find.byType(CreateAccountButton);

      // Create the Finders for sign in UI
      final signInButton = find.byType(SignInButton);

      // Use the `findsNothing` and `findsOneWidget` matcher provided by flutter_test to verify
      // that the create account UI is not shown
      expect(repeatPasswordTextField, findsNothing);
      expect(createAccountButton, findsNothing);
      expect(signInButton, findsOneWidget);
    });

    testWidgets('shows create account UI after user taps create account chip',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..otherAuthOptionsPage.mode = EmailAuthMode.signUp);

      // Create the test harness.
      final store = Store<AppState>(appReducer, initialState: alteredState);
      final wut = OtherAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders for create account UI
      final repeatPasswordTextField = find.byType(RepeatPasswordTextField);
      final createAccountButton = find.byType(CreateAccountButton);

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the create account UI is shown
      expect(repeatPasswordTextField, findsOneWidget);
      expect(createAccountButton, findsOneWidget);
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

    testWidgets('EmailTextField dispatches UpdateOtherAuthOptionsPage action ',
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
      final emailTextField = find.byType(EmailTextField);
      expect(emailTextField, findsOneWidget);

      // Type valid email
      final testEmail = 'test@email.com';
      await tester.enterText(emailTextField, testEmail);

      // check correct action is dispatched
      expect(
          testMiddleware.received(UpdateOtherAuthOptionsPage(email: testEmail)),
          true);
    });

    testWidgets(
        'PasswordTextField dispatches UpdateOtherAuthOptionsPage action',
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
      final passwordTextField = find.byType(PasswordTextField);
      expect(passwordTextField, findsOneWidget);

      // Type valid password
      final testPassword = 'test123';
      await tester.enterText(passwordTextField, testPassword);

      // check correct action is dispatched
      expect(
          testMiddleware
              .received(UpdateOtherAuthOptionsPage(password: testPassword)),
          true);
    });

    testWidgets(
        'RepeatPasswordTextField dispatches UpdateOtherAuthOptionsPage action',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..otherAuthOptionsPage.mode = EmailAuthMode.signUp);
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
      final passwordTextField = find.byType(PasswordTextField);
      final repeatPasswordTextField = find.byType(RepeatPasswordTextField);
      expect(passwordTextField, findsOneWidget);
      expect(repeatPasswordTextField, findsOneWidget);

      // Type valid password
      final testPassword = 'test123';
      await tester.enterText(repeatPasswordTextField, testPassword);

      // check correct action is dispatched
      expect(
          testMiddleware.received(
              UpdateOtherAuthOptionsPage(repeatPassword: testPassword)),
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
      expect(testMiddleware.received(SignInWithEmail()), true);
    });

    testWidgets('create account button dispatches SignUpWithEmail action',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..otherAuthOptionsPage.mode = EmailAuthMode.signUp);
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
      final createAccountButton = find.byType(CreateAccountButton);
      expect(createAccountButton, findsOneWidget);

      // Tap to show create account button
      await tester.tap(createAccountButton);

      // check correct action is dispatched
      expect(testMiddleware.received(SignUpWithEmail()), true);
    });
    testWidgets('shows loading indicator when signing in/ signing up',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState.rebuild(
          (b) => b..otherAuthOptionsPage.step = AuthStep.signingUpWithEmail);
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
      final waitingIndicator = find.byType(CircularProgressIndicator);
      expect(waitingIndicator, findsOneWidget);
    });
  });
}
