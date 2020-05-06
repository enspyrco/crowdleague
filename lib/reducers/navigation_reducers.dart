import 'package:crowdleague/models/actions/navigation/add_problem.dart';
import 'package:crowdleague/models/actions/navigation/add_route_info.dart';
import 'package:crowdleague/models/actions/navigation/remove_problem.dart';
import 'package:crowdleague/models/actions/navigation/remove_route_info.dart';
import 'package:crowdleague/models/actions/navigation/replace_route_info.dart';
import 'package:crowdleague/models/actions/navigation/store_nav_bar_selection.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app/app_state.dart';

/// Reducers specify how the application"s state changes in response to actions
/// sent to the store.
///
/// Each reducer returns a new [AppState].
final navigationReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, AddProblem>(_addProblem),
  TypedReducer<AppState, RemoveProblem>(_removeProblem),
  TypedReducer<AppState, StoreNavBarSelection>(_storeNavBarSelection),
  TypedReducer<AppState, AddRouteInfo>(_addRouteInfo),
  TypedReducer<AppState, RemoveRouteInfo>(_removeRouteInfo),
  TypedReducer<AppState, ReplaceRouteInfo>(_replaceRouteInfo),
];

AppState _addProblem(AppState state, AddProblem action) {
  return state.rebuild((b) => b..problems.add(action.problem));
}

AppState _removeProblem(AppState state, RemoveProblem action) {
  return state.rebuild((b) => b..problems.remove(action.problem));
}

AppState _addRouteInfo(AppState state, AddRouteInfo action) {
  return state.rebuild((b) => b..routes.add(action.info));
}

AppState _removeRouteInfo(AppState state, RemoveRouteInfo action) {
  return state.rebuild((b) => b..routes.remove(action.info));
}

AppState _replaceRouteInfo(AppState state, ReplaceRouteInfo action) {
  return state.rebuild((b) => b
    ..routes.remove(action.oldInfo)
    ..routes.add(action.newInfo));
}

AppState _storeNavBarSelection(AppState state, StoreNavBarSelection action) {
  return state.rebuild((b) => b..navBarSelection = action.selection);
}
