import 'package:crowdleague/actions/auth/clear_user_data.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';

void main() {
  group('ClearUserDataReducer', () {
    test('Clears any user data from state', () {
      // Create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // Dispatch action to clear user data
      store.dispatch(ClearUserData());

      // Check that the store has the expected value
      expect(store.state.user, null);
    });
    test('Resets navigation stack', () {
      // Create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // Dispatch action to clear user data
      store.dispatch(ClearUserData());

      // Check that the store has the expected value
      expect(store.state.pagesData, AppState.init().pagesData);
    });
  });
}
