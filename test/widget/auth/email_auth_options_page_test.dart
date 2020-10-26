import 'package:crowdleague/actions/auth/sign_in_with_email.dart';
import 'package:crowdleague/actions/auth/sign_up_with_email.dart';
import 'package:crowdleague/actions/auth/update_email_auth_options_page.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/enums/auto_validate.dart';
import 'package:crowdleague/enums/email_auth_mode.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/buttons/create_account_button.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/buttons/sign_in_button.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/email_auth_options_page.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/links/create_account_link.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/links/sign_in_link.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/text_fields/email_text_field.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/text_fields/password_text_field.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/text_fields/repeat_password_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

import '../../mocks/redux/redux_store_mocks.dart';
import '../../utils/verify_dispatch_middleware.dart';

void main() {
  group('EmailAuthOptionsPage', () {
    testWidgets('displays without overflowing', (WidgetTester tester) async {
      // passing test indicates no overflowing as test suite uses a small device screen

      // Setup the app state with expected values
      final initialAppState = AppState.init();

      // Create the test harness.
      final store = Store<AppState>(appReducer, initialState: initialAppState);
      final wut = EmailAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final emailAuthOptionsPage = find.byType(EmailAuthOptionsPage);

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that emailAuthOptionsPage is shown
      expect(emailAuthOptionsPage, findsOneWidget);
    });

    testWidgets('shows sign in UI when user taps sign in chip',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..emailAuthOptionsPage.mode = EmailAuthMode.signIn);

      // Create the test harness.
      final store = Store<AppState>(appReducer, initialState: alteredState);
      final wut = EmailAuthOptionsPage();
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

    testWidgets('shows create account UI when user taps create account chip',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..emailAuthOptionsPage.mode = EmailAuthMode.signUp);

      // Create the test harness.
      final store = Store<AppState>(appReducer, initialState: alteredState);
      final wut = EmailAuthOptionsPage();
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
        'dispatches UpdateEmailAuthOptionsPage action on tappping CREATE ACCOUNT link',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final testMiddleware = VerifyDispatchMiddleware();

      // Create the test harness.
      final store = Store<AppState>(appReducer,
          initialState: initialAppState, middleware: [testMiddleware]);
      final wut = EmailAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final createAccountLink = find.byType(CreateAccountLink);
      expect(createAccountLink, findsOneWidget);

      // Tap to show create account button
      await tester.tap(createAccountLink);

      // check correct action is dispatched with empty form feild values
      expect(
          testMiddleware.received(UpdateEmailAuthOptionsPage(
            mode: EmailAuthMode.signUp,
            email: '',
            password: '',
            repeatPassword: '',
            autovalidate: AutoValidate.disabled,
          )),
          true);
    });

    testWidgets(
        'dispatches UpdateEmailAuthOptionsPage action on tapping SIGN IN link',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init()
          .rebuild((b) => b..emailAuthOptionsPage.mode = EmailAuthMode.signUp);
      final testMiddleware = VerifyDispatchMiddleware();

      // Create the test harness.
      final store = Store<AppState>(appReducer,
          initialState: initialAppState, middleware: [testMiddleware]);
      final wut = EmailAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final signInLink = find.byType(SignInLink);
      expect(signInLink, findsOneWidget);

      // Tap to show create account button
      await tester.tap(signInLink);

      // check correct action is dispatched with empty form field values
      expect(
          testMiddleware.received(UpdateEmailAuthOptionsPage(
            mode: EmailAuthMode.signIn,
            email: '',
            password: '',
            repeatPassword: '',
            autovalidate: AutoValidate.disabled,
          )),
          true);
    });

    testWidgets('EmailTextField dispatches UpdateEmailAuthOptionsPage',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final testMiddleware = VerifyDispatchMiddleware();

      // Create the test harness.
      final store = Store<AppState>(appReducer,
          initialState: initialAppState, middleware: [testMiddleware]);
      final wut = EmailAuthOptionsPage();
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
          testMiddleware.received(UpdateEmailAuthOptionsPage(email: testEmail)),
          true);
    });

    testWidgets('PasswordTextField dispatches UpdateEmailAuthOptionsPage',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final testMiddleware = VerifyDispatchMiddleware();

      // Create the test harness.
      final store = Store<AppState>(appReducer,
          initialState: initialAppState, middleware: [testMiddleware]);
      final wut = EmailAuthOptionsPage();
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
              .received(UpdateEmailAuthOptionsPage(password: testPassword)),
          true);
    });

    testWidgets('RepeatPasswordTextField dispatches UpdateEmailAuthOptionsPage',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..emailAuthOptionsPage.mode = EmailAuthMode.signUp);
      final testMiddleware = VerifyDispatchMiddleware();

      // Create the test harness.
      final store = Store<AppState>(appReducer,
          initialState: alteredState, middleware: [testMiddleware]);
      final wut = EmailAuthOptionsPage();
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
              UpdateEmailAuthOptionsPage(repeatPassword: testPassword)),
          true);
    });

    testWidgets('shows loading indicator when signing in/ signing up',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState.rebuild(
          (b) => b..emailAuthOptionsPage.step = AuthStep.signingUpWithEmail);
      final testMiddleware = VerifyDispatchMiddleware();

      // Create the test harness.
      final store = Store<AppState>(appReducer,
          initialState: alteredState, middleware: [testMiddleware]);
      final wut = EmailAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final waitingIndicator = find.byType(CircularProgressIndicator);
      expect(waitingIndicator, findsOneWidget);
    });

    testWidgets(
        'After input valid email/password, signInButton dispatches SignInWithEmail action',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final testMiddleware = VerifyDispatchMiddleware();

      // Create the test harness.
      final store = Store<AppState>(appReducer,
          initialState: initialAppState, middleware: [testMiddleware]);
      final wut = EmailAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final signInButton = find.byType(SignInButton);
      expect(signInButton, findsOneWidget);
      final emailTextField = find.byType(EmailTextField);
      expect(emailTextField, findsOneWidget);
      final passwordTextField = find.byType(PasswordTextField);
      expect(passwordTextField, findsOneWidget);

      // Input valid email and password
      await tester.enterText(emailTextField, 'test@email.com');
      await tester.enterText(passwordTextField, 'password123');

      // Tap to validate valid form
      await tester.tap(signInButton);

      // Check that form is valid and action is dispatched
      expect(testMiddleware.received(SignInWithEmail()), true);
    });

    testWidgets(
        'CreateAccountButton only dispatches when all textfields are valid',
        (WidgetTester tester) async {
      // Setup a fake store and test harness with intial values.
      final fakeStore = FakeStore(
          updates: (b) => b..emailAuthOptionsPage.mode = EmailAuthMode.signUp);
      final wut = EmailAuthOptionsPage();
      final harness = StoreProvider<AppState>(
          store: fakeStore, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create Finders for text fields and create account button.
      final createAccountButton = find.byType(CreateAccountButton);
      final emailTextField = find.byType(EmailTextField);
      final passwordTextField = find.byType(PasswordTextField);
      final repeatPasswordTextField = find.byType(RepeatPasswordTextField);

      // Check that all the expected widgets are present.
      expect(createAccountButton, findsOneWidget);
      expect(emailTextField, findsOneWidget);
      expect(passwordTextField, findsOneWidget);
      expect(repeatPasswordTextField, findsOneWidget);

      // Create Finders for the text shown by the textfields when invalid.
      final invalidEmailText = find.text('please enter a valid email');
      final invalidPasswordText =
          find.text('password must be between 6 and 30 characters');
      final invalidRepeatPasswordText = find.text('passwords do not match');

      // Input invalid details.
      await tester.enterText(emailTextField, 'invalid_email');
      await tester.enterText(passwordTextField, '123');
      await tester.enterText(repeatPasswordTextField, '12345');

      // Submit invalid form.
      await tester.tap(createAccountButton);

      // Check that the widget dispatched the expected action.
      expect(
          fakeStore.dispatchedActions,
          contains(UpdateEmailAuthOptionsPage(
              autovalidate: AutoValidate.onUserInteraction)));

      // Update the state in response to the actions.
      fakeStore.updateState((b) => b
        ..emailAuthOptionsPage.autovalidate = AutoValidate.onUserInteraction);

      await tester.pumpAndSettle();

      // Check formfield error messages are shown.
      expect(invalidEmailText, findsOneWidget);
      expect(invalidPasswordText, findsOneWidget);
      expect(invalidRepeatPasswordText, findsOneWidget);

      // Input valid email and password.
      await tester.enterText(emailTextField, 'test@email.com');
      await tester.enterText(passwordTextField, 'password123');
      await tester.enterText(repeatPasswordTextField, 'password123');

      // Check that the widget dispatched the expected actions.
      expect(
          fakeStore.dispatchedActions,
          containsAll(<ReduxAction>[
            UpdateEmailAuthOptionsPage(email: 'test@email.com'),
            UpdateEmailAuthOptionsPage(password: 'password123'),
            UpdateEmailAuthOptionsPage(repeatPassword: 'password123')
          ]));

      // Update the state in response to the actions.
      fakeStore.updateState((b) => b
        ..emailAuthOptionsPage.email = 'test@email.com'
        ..emailAuthOptionsPage.password = 'password123'
        ..emailAuthOptionsPage.repeatPassword = 'password123');

      await tester.pumpAndSettle();

      // Check that invalid messages are gone
      expect(invalidEmailText, findsNothing);
      expect(invalidPasswordText, findsNothing);
      expect(invalidRepeatPasswordText, findsNothing);

      // Tap to validate valid form.
      await tester.tap(createAccountButton);

      // Check that form is valid and action is dispatched
      expect(fakeStore.dispatchedActions, contains(SignUpWithEmail()));
    });

    testWidgets(
        'With no form input, CreateAccountButton shows validation errors',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..emailAuthOptionsPage.mode = EmailAuthMode.signUp);
      final testMiddleware = VerifyDispatchMiddleware();

      // Create the test harness.
      final store = Store<AppState>(appReducer,
          initialState: alteredState, middleware: [testMiddleware]);
      final wut = EmailAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final createAccountButton = find.byType(CreateAccountButton);
      expect(createAccountButton, findsOneWidget);

      final emptyEmailFieldError = find.text('please enter email');
      final emptyPasswordFieldError = find.text('please enter password');
      final emptyRepeatPasswordFieldError =
          find.text('please enter password again');
      expect(emptyEmailFieldError, findsNothing);
      expect(emptyPasswordFieldError, findsNothing);
      expect(emptyRepeatPasswordFieldError, findsNothing);

      // Tap to validate form
      await tester.tap(createAccountButton);

      // Wait for changes to show
      await tester.pumpAndSettle();

      // Check that form shows validation error messages
      expect(emptyEmailFieldError, findsOneWidget);
      expect(emptyPasswordFieldError, findsOneWidget);
      expect(emptyRepeatPasswordFieldError, findsOneWidget);

      // Check that SignUpWithEmail action does not get called
      expect(testMiddleware.received(SignUpWithEmail()), false);
    });

    testWidgets(
        'With no input in form fields, on tap sign in shows validation errors',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final testMiddleware = VerifyDispatchMiddleware();

      // Create the test harness.
      final store = Store<AppState>(appReducer,
          initialState: initialAppState, middleware: [testMiddleware]);
      final wut = EmailAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final signInButton = find.byType(SignInButton);
      expect(signInButton, findsOneWidget);
      final emptyEmailFieldError = find.text('please enter email');
      final emptyPasswordFieldError = find.text('please enter password');
      expect(emptyEmailFieldError, findsNothing);
      expect(emptyPasswordFieldError, findsNothing);

      // Tap to validate form
      await tester.tap(signInButton);

      // Wait for changes to show
      await tester.pumpAndSettle();

      // Check that form shows validation error messages
      expect(emptyEmailFieldError, findsOneWidget);
      expect(emptyPasswordFieldError, findsOneWidget);

      // Check that SignInWithEmail action does not get called
      expect(testMiddleware.received(SignInWithEmail()), false);
    });

    testWidgets('On sign up, prompt user to correct invalid form feilds',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final alteredState = initialAppState
          .rebuild((b) => b..emailAuthOptionsPage.mode = EmailAuthMode.signUp);
      final testMiddleware = VerifyDispatchMiddleware();

      // Create the test harness.
      final store = Store<AppState>(appReducer,
          initialState: alteredState, middleware: [testMiddleware]);
      final wut = EmailAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final createAccountButton = find.byType(CreateAccountButton);
      expect(createAccountButton, findsOneWidget);
      final emailTextField = find.byType(EmailTextField);
      expect(emailTextField, findsOneWidget);
      final passwordTextField = find.byType(PasswordTextField);
      expect(passwordTextField, findsOneWidget);
      final repeatPasswordTextField = find.byType(RepeatPasswordTextField);
      expect(repeatPasswordTextField, findsOneWidget);
      final invalidEmailText = find.text('please enter a valid email');
      final invalidPasswordText =
          find.text('password must be between 6 and 30 characters');
      final invalidRepeatPasswordText = find.text('passwords do not match');

      // input invalid details
      await tester.enterText(emailTextField, 'invalid_email');
      await tester.enterText(passwordTextField, '123');
      await tester.enterText(repeatPasswordTextField, '12345');

      // submit invalid form
      await tester.tap(createAccountButton);

      // wait for changes to show
      await tester.pumpAndSettle();

      // check formfeild error messages are shown
      expect(invalidEmailText, findsOneWidget);
      expect(invalidPasswordText, findsOneWidget);
      expect(invalidRepeatPasswordText, findsOneWidget);
    });

    testWidgets('On sign in, prompt user to correct invalid form feilds',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final testMiddleware = VerifyDispatchMiddleware();

      // Create the test harness.
      final store = Store<AppState>(appReducer,
          initialState: initialAppState, middleware: [testMiddleware]);
      final wut = EmailAuthOptionsPage();
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create the Finders.
      final signInButton = find.byType(SignInButton);
      expect(signInButton, findsOneWidget);
      final emailTextField = find.byType(EmailTextField);
      expect(emailTextField, findsOneWidget);
      final passwordTextField = find.byType(PasswordTextField);
      expect(passwordTextField, findsOneWidget);

      // invalid fields finders
      final invalidEmailText = find.text('please enter a valid email');
      final invalidPasswordText =
          find.text('password must be between 6 and 30 characters');

      // input invalid details
      await tester.enterText(emailTextField, 'invalid_email');
      await tester.enterText(passwordTextField, '123');

      // submit invalid form
      await tester.tap(signInButton);

      // wait for changes to show
      await tester.pumpAndSettle();

      // check formfield error messages are shown
      expect(invalidEmailText, findsOneWidget);
      expect(invalidPasswordText, findsOneWidget);

      // check sign in button didnt dispatch SignInWithEmail action
      expect(testMiddleware.received(SignInWithEmail()), false);
    });

    testWidgets('form autovalidates after a sign in attempt',
        (WidgetTester tester) async {
      // Setup test doubles.
      final fakeStore = FakeStore();
      final wut = EmailAuthOptionsPage();
      final harness = StoreProvider<AppState>(
          store: fakeStore, child: MaterialApp(home: wut));

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness);

      // Create Finders for the text fields and check they are present.
      final signInButton = find.byType(SignInButton);
      final emailTextField = find.byType(EmailTextField);
      final passwordTextField = find.byType(PasswordTextField);
      expect(signInButton, findsOneWidget);
      expect(emailTextField, findsOneWidget);
      expect(passwordTextField, findsOneWidget);

      // Create Finders for the invalid text and check they are not present.
      final invalidEmailText = find.text('please enter a valid email');
      final invalidPasswordText =
          find.text('password must be between 6 and 30 characters');
      expect(invalidEmailText, findsNothing);
      expect(invalidPasswordText, findsNothing);

      // Input invalid details.
      await tester.enterText(emailTextField, 'invalid_email');
      await tester.enterText(passwordTextField, '123');

      // Attempt signing in.
      await tester.tap(signInButton);

      await tester.pumpAndSettle();

      // Check formfield error messages are shown.
      expect(invalidEmailText, findsOneWidget);
      expect(invalidPasswordText, findsOneWidget);

      fakeStore.updateState((b) => b
        ..emailAuthOptionsPage.autovalidate = AutoValidate.onUserInteraction);

      // Enter valid details.
      await tester.enterText(emailTextField, 'valid@email.com');
      await tester.enterText(passwordTextField, 'validPassword');

      // Let autovalidation remove error messages.
      await tester.pumpAndSettle();

      // Check error messages are gone.
      expect(invalidEmailText, findsNothing);
      expect(invalidPasswordText, findsNothing);
    });

    testWidgets(
        'After tap create account with invalid details, form autovalidates on user input',
        (WidgetTester tester) async {
      // Setup the test doubles.
      final fakeStore = FakeStore(
          updates: (b) => b..emailAuthOptionsPage.mode = EmailAuthMode.signUp);
      final wut = EmailAuthOptionsPage();
      final harness = StoreProvider<AppState>(
          store: fakeStore, child: MaterialApp(home: wut));

      // Build the widget tree.
      await tester.pumpWidget(harness);

      // Create Finders for the text fields and create account button and check
      // they are present.
      final createAccountButton = find.byType(CreateAccountButton);
      final emailTextField = find.byType(EmailTextField);
      final passwordTextField = find.byType(PasswordTextField);
      final repeatPasswordTextField = find.byType(RepeatPasswordTextField);
      expect(createAccountButton, findsOneWidget);
      expect(emailTextField, findsOneWidget);
      expect(passwordTextField, findsOneWidget);
      expect(repeatPasswordTextField, findsOneWidget);

      // Create Finders for the invalid text and check they are not present.
      final invalidEmailText = find.text('please enter a valid email');
      final invalidPasswordText =
          find.text('password must be between 6 and 30 characters');
      final invalidRepeatPasswordText = find.text('passwords do not match');
      expect(invalidEmailText, findsNothing);
      expect(invalidPasswordText, findsNothing);
      expect(invalidRepeatPasswordText, findsNothing);

      // Enter invalid details.
      await tester.enterText(emailTextField, 'invalid_email');
      await tester.enterText(passwordTextField, '123');
      await tester.enterText(repeatPasswordTextField, '0');

      // Attempt to create account.
      await tester.tap(createAccountButton);

      // Check that the widget dispatched the expected action.
      expect(
          fakeStore.dispatchedActions,
          contains(UpdateEmailAuthOptionsPage(
              autovalidate: AutoValidate.onUserInteraction)));

      // Update the state in response to the action.
      fakeStore.updateState((b) => b
        ..emailAuthOptionsPage.autovalidate = AutoValidate.onUserInteraction);

      await tester.pumpAndSettle();

      // Check formfield error messages are shown.
      expect(invalidEmailText, findsOneWidget);
      expect(invalidPasswordText, findsOneWidget);
      expect(invalidRepeatPasswordText, findsOneWidget);

      // Enter valid details.
      await tester.enterText(emailTextField, 'valid@email.com');
      await tester.enterText(passwordTextField, 'validPassword');
      await tester.enterText(repeatPasswordTextField, 'validPassword');

      // Check that the widget dispatched the expected actions.
      expect(
          fakeStore.dispatchedActions,
          containsAll(<ReduxAction>[
            UpdateEmailAuthOptionsPage(email: 'valid@email.com'),
            UpdateEmailAuthOptionsPage(password: 'validPassword'),
            UpdateEmailAuthOptionsPage(repeatPassword: 'validPassword')
          ]));

      // Update the state in response to the actions.
      fakeStore.updateState((b) => b
        ..emailAuthOptionsPage.email = 'valid@email.com'
        ..emailAuthOptionsPage.password = 'validPassword'
        ..emailAuthOptionsPage.repeatPassword = 'validPassword');

      // Let autovalidation remove error messages.
      await tester.pumpAndSettle();

      // Check error messages are gone.
      expect(invalidEmailText, findsNothing);
      expect(invalidPasswordText, findsNothing);
      expect(invalidRepeatPasswordText, findsNothing);
    });
  });
}
