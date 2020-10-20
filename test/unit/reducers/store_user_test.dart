import 'package:crowdleague/actions/auth/store_user.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';

import '../../mocks/models/user_mocks.dart';

void main() {
  group('StoreUserReducer', () {
    test('Adds new user to store', () {
      // Init mocks
      final testUser = mockUser;

      // Create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // Dispatch action
      store.dispatch(StoreUser(user: testUser));

      // Check that the store has the expected value
      expect(store.state.user, testUser);
    });
    test('Resets navigation stack', () {
      // Init mocks
      final testUser = mockUser;

      // Create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // Dispatch action
      store.dispatch(StoreUser(user: testUser));

      // Check that the store has the expected value
      expect(store.state.pagesData, AppState.init().pagesData);
    });
  });
}
