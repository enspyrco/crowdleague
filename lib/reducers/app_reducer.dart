import 'package:crowdleague/models/actions/add_problem.dart';
import 'package:crowdleague/models/actions/remove_problem.dart';
import 'package:crowdleague/reducers/auth_reducers.dart';
import 'package:crowdleague/reducers/navigation_reducers.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app/app_state.dart';

/// Reducers specify how the application"s state changes in response to actions
/// sent to the store.
///
/// Each reducer returns a new [AppState].
final appReducer =
    combineReducers<AppState>(<AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, AddProblem>(_addProblem),
  TypedReducer<AppState, RemoveProblem>(_removeProblem),
  ...authReducers,
  ...navigationReducers,
]);

AppState _addProblem(AppState state, AddProblem action) {
  return state.rebuild((b) => b..problems.add(action.problem));
}

AppState _removeProblem(AppState state, RemoveProblem action) {
  return state.rebuild((b) => b..problems.remove(action.problem));
}
