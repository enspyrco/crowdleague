import 'package:crowdleague/actions/auth/store_auth_step.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';

void main() {
  group('StoreAuthStepReducer', () {
    test('Updates step for emailAuthOptionsPage', () {
      // Create data for action
      final testStep = AuthStep.waitingForInput;

      // Create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // Dispatch action to clear user data
      store.dispatch(StoreAuthStep(step: testStep));

      // Check that the store has the expected value
      expect(store.state.emailAuthOptionsPage.step, testStep);
    });
    test('Updates step for authPage', () {
      // Create data for action
      final testStep = AuthStep.waitingForInput;

      // Create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // Dispatch action to clear user data
      store.dispatch(StoreAuthStep(step: testStep));

      // Check that the store has the expected value
      expect(store.state.authPage.step, testStep);
    });
  });
}
