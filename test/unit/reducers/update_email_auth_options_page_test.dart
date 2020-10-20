import 'package:crowdleague/actions/auth/update_email_auth_options_page.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/enums/auto_validate.dart';
import 'package:crowdleague/enums/email_auth_mode.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';

void main() {
  group('UpdateEmailAuthOptionsPageReducer', () {
    test('updates store.emailAuthOptionsPage.mode', () {
      // Create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // Create data to send with action
      final testSignUpMode = EmailAuthMode.signUp;
      final testSignInMode = EmailAuthMode.signIn;

      // Dispatch action
      store.dispatch(UpdateEmailAuthOptionsPage(mode: testSignUpMode));

      // Check that the store has the expected value
      expect(store.state.emailAuthOptionsPage.mode, testSignUpMode);

      // Dispatch action
      store.dispatch(UpdateEmailAuthOptionsPage(mode: testSignInMode));

      // Check that the store has the expected value
      expect(store.state.emailAuthOptionsPage.mode, testSignInMode);
    });
    test('updates store.emailAuthOptionsPage.showPassword', () {
      // Create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // Dispatch action
      store.dispatch(UpdateEmailAuthOptionsPage(showPassword: true));

      // Check that the store has the expected value
      expect(store.state.emailAuthOptionsPage.showPassword, true);

      // Dispatch action
      store.dispatch(UpdateEmailAuthOptionsPage(showPassword: false));

      // Check that the store has the expected value
      expect(store.state.emailAuthOptionsPage.showPassword, false);
    });
    test('updates store.emailAuthOptionsPage.step', () {
      // Create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // Dispatch action
      store.dispatch(
          UpdateEmailAuthOptionsPage(step: AuthStep.signingInWithEmail));

      // Check that the store has the expected value
      expect(
          store.state.emailAuthOptionsPage.step, AuthStep.signingInWithEmail);

      // Dispatch action
      store
          .dispatch(UpdateEmailAuthOptionsPage(step: AuthStep.waitingForInput));

      // Check that the store has the expected value
      expect(store.state.emailAuthOptionsPage.step, AuthStep.waitingForInput);
    });
    test('updates store.emailAuthOptionsPage.email', () {
      // Create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // Create data to send with action
      final testEmail = 'test@email.com';

      // Dispatch action
      store.dispatch(UpdateEmailAuthOptionsPage(email: testEmail));

      // Check that the store has the expected value
      expect(store.state.emailAuthOptionsPage.email, testEmail);
    });
    test('updates store.emailAuthOptionsPage.password', () {
      // Create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // Create data to send with action
      final testPassword = 'test_password';

      // Dispatch action
      store.dispatch(UpdateEmailAuthOptionsPage(password: testPassword));

      // Check that the store has the expected value
      expect(store.state.emailAuthOptionsPage.password, testPassword);
    });
    test('updates store.emailAuthOptionsPage.repeatPassword', () {
      // Create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // Create data to send with action
      final testRepeatPassword = 'test_repeat_password';

      // Dispatch action
      store.dispatch(
          UpdateEmailAuthOptionsPage(repeatPassword: testRepeatPassword));

      // Check that the store has the expected value
      expect(
          store.state.emailAuthOptionsPage.repeatPassword, testRepeatPassword);
    });

    test('updates store.emailAuthOptionsPage.autovalidate', () {
      // Create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // Dispatch action
      store.dispatch(UpdateEmailAuthOptionsPage(
          autovalidate: AutoValidate.onUserInteraction));

      // Check that the store has the expected value
      expect(store.state.emailAuthOptionsPage.autovalidate,
          AutoValidate.onUserInteraction);

      // Dispatch action
      store.dispatch(
          UpdateEmailAuthOptionsPage(autovalidate: AutoValidate.disabled));

      // Check that the store has the expected value
      expect(
          store.state.emailAuthOptionsPage.autovalidate, AutoValidate.disabled);
    });
    test('updates store.emailAuthOptionsPage.autovalidate', () {
      // Create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // Dispatch action
      store.dispatch(UpdateEmailAuthOptionsPage(
          autovalidate: AutoValidate.onUserInteraction));

      // Check that the store has the expected value
      expect(store.state.emailAuthOptionsPage.autovalidate,
          AutoValidate.onUserInteraction);

      // Dispatch action
      store.dispatch(
          UpdateEmailAuthOptionsPage(autovalidate: AutoValidate.disabled));

      // Check that the store has the expected value
      expect(
          store.state.emailAuthOptionsPage.autovalidate, AutoValidate.disabled);
    });
  });
}
