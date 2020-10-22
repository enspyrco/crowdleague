import 'package:crowdleague/actions/auth/update_email_auth_options_page.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/enums/auto_validate.dart';
import 'package:crowdleague/enums/email_auth_mode.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/auth/update_email_auth_options_page.dart';
import 'package:test/test.dart';

void main() {
  group('UpdateEmailAuthOptionsPageReducer', () {
    test('updates state.emailAuthOptionsPage.mode', () {
      // Setup an initial app state
      final initialState = AppState.init();
      expect(initialState.emailAuthOptionsPage.mode, EmailAuthMode.signIn);

      // Create the reducer.
      final rut = UpdateEmailAuthOptionsPageReducer();

      // Invoke the reducer to get a new state.
      final newStateSignUp = rut.reducer(
          initialState, UpdateEmailAuthOptionsPage(mode: EmailAuthMode.signUp));

      // Check that the new state has the updated emailAuthMode.
      expect(newStateSignUp.emailAuthOptionsPage.mode, EmailAuthMode.signUp);
    });

    test('updates state.emailAuthOptionsPage.showPassword', () {
      // Setup an initial app state
      final initialState = AppState.init();
      expect(initialState.emailAuthOptionsPage.showPassword, false);

      // Create the reducer.
      final rut = UpdateEmailAuthOptionsPageReducer();

      // Invoke the reducer to get a new state.
      final newStateSignUp = rut.reducer(
          initialState, UpdateEmailAuthOptionsPage(showPassword: true));

      // Check that the new state has the updated showPassword value.
      expect(newStateSignUp.emailAuthOptionsPage.showPassword, true);
    });

    test('updates state.emailAuthOptionsPage.step', () {
      // Setup an initial app state
      final initialState = AppState.init();
      expect(initialState.emailAuthOptionsPage.step, AuthStep.waitingForInput);

      // Create the reducer.
      final rut = UpdateEmailAuthOptionsPageReducer();

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(initialState,
          UpdateEmailAuthOptionsPage(step: AuthStep.signingInWithEmail));

      // Check that the new state has the updated authStep value.
      expect(newState.emailAuthOptionsPage.step, AuthStep.signingInWithEmail);
    });

    test('updates state.emailAuthOptionsPage.email', () {
      // Setup an initial app state
      final initialState = AppState.init();
      expect(initialState.emailAuthOptionsPage.email, '');

      // Create the reducer.
      final rut = UpdateEmailAuthOptionsPageReducer();

      // Create data for action
      final testEmail = 'test@email.com';

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(
          initialState, UpdateEmailAuthOptionsPage(email: testEmail));

      // Check that the new state has the new email.
      expect(newState.emailAuthOptionsPage.email, testEmail);
    });

    test('updates state.emailAuthOptionsPage.password', () {
      // Setup an initial app state
      final initialState = AppState.init();
      expect(initialState.emailAuthOptionsPage.password, '');

      // Create the reducer.
      final rut = UpdateEmailAuthOptionsPageReducer();

      // Create data to send with action
      final testPassword = 'test_password';

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(
          initialState, UpdateEmailAuthOptionsPage(password: testPassword));

      // Check that the new state has the new password.
      expect(newState.emailAuthOptionsPage.password, testPassword);
    });

    test('updates state.emailAuthOptionsPage.repeatPassword', () {
      // Setup an initial app state
      final initialState = AppState.init();
      expect(initialState.emailAuthOptionsPage.repeatPassword, '');

      // Create the reducer.
      final rut = UpdateEmailAuthOptionsPageReducer();

      // Create data to send with action
      final testRepeatPassword = 'test_password';

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(initialState,
          UpdateEmailAuthOptionsPage(repeatPassword: testRepeatPassword));

      // Check that the new state has the updated repeat password value.
      expect(newState.emailAuthOptionsPage.repeatPassword, testRepeatPassword);
    });

    test('updates state.emailAuthOptionsPage.autovalidate', () {
      // Setup an initial app state
      final initialState = AppState.init();
      expect(initialState.emailAuthOptionsPage.autovalidate,
          AutoValidate.disabled);

      // Create the reducer.
      final rut = UpdateEmailAuthOptionsPageReducer();

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(
          initialState,
          UpdateEmailAuthOptionsPage(
              autovalidate: AutoValidate.onUserInteraction));

      // Check that the new state has the updated autovalidate value.
      expect(newState.emailAuthOptionsPage.autovalidate,
          AutoValidate.onUserInteraction);
    });
  });
}
