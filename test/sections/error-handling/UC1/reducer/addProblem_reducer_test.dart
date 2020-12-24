import 'package:crowdleague/actions/navigation/store_nav_bar_selection.dart';
import 'package:crowdleague/enums/navigation/nav_bar_selection.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:crowdleague/reducers/navigation/store_nav_bar_selection.dart';
import 'package:test/test.dart';

void main() {
  group('AddProblemReducer', () {
    test('Adds Problem to appState.problems and ProblemPageData to appState.pagesData', () {
      // Setup initial app state.
      final initialState = AppState.init();
      expect(initialState.navBarSelection.name, 'home');

      // Create the reducer to test.
      final reducer = AddProblemReducer();

      // Invoke the reducer to rebuild appState.
      final newState = reducer.reducer(
        initialState,
        AddProblemReducer(
          
        ),
      );

      // Check that the new state has the new navbarSelection.
      expect(newState.navBarSelection.name, 'venues');
    });
  });
}