import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/navigation/page_data/problem_page_data.dart';
import 'package:crowdleague/models/problems/general_problem.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:crowdleague/utils/problem_utils.dart';
import 'package:test/test.dart';

void main() {
  group('AddProblemReducer', () {
    test(
        'Adds Problem to appState.problems and ProblemPageData to appState.pagesData',
        () {
      // Setsup the initial app state.
      final initialState = AppState.init();
      
      expect(initialState.problems.length, 0);
      expect(initialState.pagesData.length, 1);

      final reducer = AddProblemReducer();
      final problem = createProblem(
          GeneralProblem, 'Problem error message', StackTrace.current);

      // Invokes the reducer to rebuild appState.
      final newState =
          reducer.reducer(initialState, AddProblem(problem: problem));

      expect(newState.problems.first, problem);
      expect(newState.pagesData.length, 2);
      expect((newState.pagesData[1] as ProblemPageData).problem.message,
          problem.message);
    });
  });
}
