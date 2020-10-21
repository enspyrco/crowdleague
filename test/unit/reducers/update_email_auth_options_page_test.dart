import 'package:crowdleague/actions/auth/update_email_auth_options_page.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/enums/auto_validate.dart';
import 'package:crowdleague/enums/email_auth_mode.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/auth/update_email_auth_options_page.dart';
import 'package:test/test.dart';

void main() {
  group('UpdateEmailAuthOptionsPageReducer', () {
    test('updates store.emailAuthOptionsPage.mode', () {
      // Setup an initial app state
      final initialState = AppState.init();

      // Create the reducer.
      final rut = UpdateEmailAuthOptionsPageReducer();

      // Create data to send with action
      final testSignUpMode = EmailAuthMode.signUp;
      final testSignInMode = EmailAuthMode.signIn;

      // Invoke the reducer to get a new state.
      final newStateSignUp = rut.reducer(
          initialState, UpdateEmailAuthOptionsPage(mode: testSignUpMode));

      // Check that the new state has the new user.
      expect(newStateSignUp.emailAuthOptionsPage.mode, testSignUpMode);

      // Invoke the reducer to get a new state.
      final newStateSignIn = rut.reducer(
          initialState, UpdateEmailAuthOptionsPage(mode: testSignInMode));

      // Check that the new state has the new user.
      expect(newStateSignIn.emailAuthOptionsPage.mode, testSignInMode);
    });
    test('updates store.emailAuthOptionsPage.showPassword', () {
      // Setup an initial app state
      final initialState = AppState.init();

      // Create the reducer.
      final rut = UpdateEmailAuthOptionsPageReducer();

      // Invoke the reducer to get a new state.
      final newStateSignUp = rut.reducer(
          initialState, UpdateEmailAuthOptionsPage(showPassword: true));

      // Check that the new state has the new user.
      expect(newStateSignUp.emailAuthOptionsPage.showPassword, true);
    });
    test('updates store.emailAuthOptionsPage.step', () {
      // Setup an initial app state
      final initialState = AppState.init();

      // Create the reducer.
      final rut = UpdateEmailAuthOptionsPageReducer();

      // Create data for action
      final testStep = AuthStep.waitingForInput;

      // Invoke the reducer to get a new state.
      final newState =
          rut.reducer(initialState, UpdateEmailAuthOptionsPage(step: testStep));

      // Check that the new state has the new user.
      expect(newState.emailAuthOptionsPage.step, testStep);
    });
    test('updates store.emailAuthOptionsPage.email', () {
      // Setup an initial app state
      final initialState = AppState.init();

      // Create the reducer.
      final rut = UpdateEmailAuthOptionsPageReducer();

      // Create data for action
      final testEmail = 'test@email.com';

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(
          initialState, UpdateEmailAuthOptionsPage(email: testEmail));

      // Check that the new state has the new user.
      expect(newState.emailAuthOptionsPage.email, testEmail);
    });
    test('updates store.emailAuthOptionsPage.password', () {
      // Setup an initial app state
      final initialState = AppState.init();

      // Create the reducer.
      final rut = UpdateEmailAuthOptionsPageReducer();

      // Create data to send with action
      final testPassword = 'test_password';

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(
          initialState, UpdateEmailAuthOptionsPage(password: testPassword));

      // Check that the new state has the new user.
      expect(newState.emailAuthOptionsPage.password, testPassword);
    });
    test('updates store.emailAuthOptionsPage.repeatPassword', () {
      // Setup an initial app state
      final initialState = AppState.init();

      // Create the reducer.
      final rut = UpdateEmailAuthOptionsPageReducer();

      // Create data to send with action
      final testRepeatPassword = 'test_password';

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(initialState,
          UpdateEmailAuthOptionsPage(repeatPassword: testRepeatPassword));

      // Check that the new state has the new user.
      expect(newState.emailAuthOptionsPage.repeatPassword, testRepeatPassword);
    });

    test('updates store.emailAuthOptionsPage.autovalidate', () {
      // Setup an initial app state
      final initialState = AppState.init();

      // Create the reducer.
      final rut = UpdateEmailAuthOptionsPageReducer();

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(
          initialState,
          UpdateEmailAuthOptionsPage(
              autovalidate: AutoValidate.onUserInteraction));

      // Check that the new state has the new user.
      expect(newState.emailAuthOptionsPage.autovalidate,
          AutoValidate.onUserInteraction);
    });
  });
}
