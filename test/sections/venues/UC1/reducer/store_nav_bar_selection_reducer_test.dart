import 'package:crowdleague/actions/navigation/store_nav_bar_selection.dart';
import 'package:crowdleague/enums/navigation/nav_bar_selection.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/navigation/store_nav_bar_selection.dart';
import 'package:test/test.dart';

void main() {
  group('StoreNavBarSelection', () {
    test('sets AppState.navBarSelection to venues', () {
      // Setup an initial app state
      final initialState = AppState.init();
      expect(initialState.navBarSelection.name, 'home');

      // Create the reducer.
      final rut = StoreNavBarSelectionReducer();

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(
        initialState,
        StoreNavBarSelection(
          selection: NavBarSelection.valueOfIndex(1),
        ),
      );

      // Check that the new state has the new navbarSelection.
      expect(newState.navBarSelection.name, 'venues');
    });
  });
}
