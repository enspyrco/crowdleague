import 'package:crowdleague/actions/auth/store_auth_step.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/auth/store_auth_step.dart';
import 'package:test/test.dart';

void main() {
  group('StoreAuthStepReducer', () {
    test('updates step for emailAuthOptionsPage', () {
      // Setup an initial app state
      final initialState = AppState.init();

      // Create the reducer.
      final rut = StoreAuthStepReducer();

      // Create data for action
      final testStep = AuthStep.waitingForInput;

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(initialState, StoreAuthStep(step: testStep));

      // Check that the new state has the new user.
      expect(newState.emailAuthOptionsPage.step, testStep);
    });
    test('Updates step for authPage', () {
      // Setup an initial app state
      final initialState = AppState.init();

      // Create the reducer.
      final rut = StoreAuthStepReducer();

      // Create data for action
      final testStep = AuthStep.waitingForInput;

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(initialState, StoreAuthStep(step: testStep));

      // Check that the new state has the new user.
      expect(newState.authPage.step, testStep);
    });
  });
}
