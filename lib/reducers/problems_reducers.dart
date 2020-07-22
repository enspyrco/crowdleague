import 'package:crowdleague/actions/problems/add_problem.dart';
import 'package:crowdleague/actions/problems/remove_problem.dart';
import 'package:crowdleague/actions/problems/set_displaying_problem.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app/app_state.dart';

/// Reducers specify how the application"s state changes in response to actions
/// sent to the store.
///
/// Each reducer returns a new [AppState].
final problemsReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, AddProblem>(_addProblem),
  TypedReducer<AppState, SetDisplayingProblem>(_setDisplayingProblem),
  TypedReducer<AppState, RemoveProblem>(_removeProblem),
];

AppState _addProblem(AppState state, AddProblem action) {
  return state.rebuild((b) => b..problems.add(action.problem));
}

/// Change the app state to indicate whether or not there is a problem being
/// displayed.
AppState _setDisplayingProblem(AppState state, SetDisplayingProblem action) {
  return state.rebuild((b) => b..displayingProblem = action.displaying);
}

/// Remove the problem from the list.
AppState _removeProblem(AppState state, RemoveProblem action) {
  return state.rebuild((b) => b..problems.remove(action.problem));
}
