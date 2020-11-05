import 'package:crowdleague/actions/auth/store_auth_step.dart';
import 'package:crowdleague/enums/auth/auth_step.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/auth/store_auth_step.dart';
import 'package:test/test.dart';

void main() {
  group('StoreAuthStepReducer', () {
    test('updates AuthStep value in EmailAuthOptionsPage', () {
      // Setup an initial app state
      final initialState = AppState.init();
      expect(initialState.emailAuthOptionsPage.step, AuthStep.waitingForInput);

      // Create the reducer.
      final rut = StoreAuthStepReducer();

      // Create data for action
      final testStep = AuthStep.signingInWithEmail;

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(initialState, StoreAuthStep(step: testStep));

      // Check that the new state has the updated AuthStep value.
      expect(newState.emailAuthOptionsPage.step, testStep);
    });

    test('updates AuthStep value in AuthPage', () {
      // Setup an initial app state
      final initialState = AppState.init();
      expect(initialState.authPage.step, AuthStep.waitingForInput);

      // Create the reducer.
      final rut = StoreAuthStepReducer();

      // Create data for action
      final testStep = AuthStep.signingInWithApple;

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(initialState, StoreAuthStep(step: testStep));

      // Check that the new state has the updated AuthStep value.
      expect(newState.authPage.step, testStep);
    });
  });
}
