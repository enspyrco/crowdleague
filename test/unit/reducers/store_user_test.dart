import 'package:crowdleague/actions/auth/store_user.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/auth/store_user.dart';
import 'package:test/test.dart';

import '../../mocks/models/user_mocks.dart';

void main() {
  group('StoreUserReducer', () {
    test('adds new user to store', () {
      // Setup an initial app state
      final initialState = AppState.init();

      // Create the reducer.
      final rut = StoreUserReducer();

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(initialState, StoreUser(user: mockUser));

      // Check that the new state has the new user.
      expect(newState.user, mockUser);
    });
    test('resets navigation stack', () {
      // Setup an initial app state .
      final initialState = AppState.init();

      // Create the reducer.
      final rut = StoreUserReducer();

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(initialState, StoreUser(user: mockUser));

      // Check that the new state has null for the user.
      expect(newState.pagesData, initialState.pagesData);
    });
  });
}
