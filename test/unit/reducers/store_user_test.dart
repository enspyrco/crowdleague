import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/actions/auth/store_user.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/navigation/page_data/email_auth_page_data.dart';
import 'package:crowdleague/models/navigation/page_data/page_data.dart';
import 'package:crowdleague/reducers/auth/store_user.dart';
import 'package:test/test.dart';

import '../../mocks/models/user_mocks.dart';

void main() {
  group('StoreUserReducer', () {
    test('adds new User to AppState', () {
      // Setup an initial app state
      final initialState = AppState.init();
      expect(initialState.user, null);

      // Create the reducer.
      final rut = StoreUserReducer();

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(initialState, StoreUser(user: mockUser));

      // Check that the new state has the new user.
      expect(newState.user, mockUser);
    });

    test('resets list of PageData objects', () {
      // Setup an initial app state with EmailAuthPageData in pageData list
      final initialState = AppState.init().rebuild(
        (b) => b..pagesData = ListBuilder(<PageData>[EmailAuthPageData()]),
      );

      // Create the reducer.
      final rut = StoreUserReducer();

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(initialState, StoreUser(user: mockUser));

      // Check that the new state has the initial pageData list
      expect(newState.pagesData, AppState.init().pagesData);
    });
  });
}
