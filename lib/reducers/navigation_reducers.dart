import 'package:crowdleague/actions/problems/add_problem.dart';
import 'package:crowdleague/actions/navigation/record_added_route_info.dart';
import 'package:crowdleague/actions/navigation/record_removed_route_info.dart';
import 'package:crowdleague/actions/navigation/record_replaced_route_info.dart';
import 'package:crowdleague/actions/problems/remove_problem.dart';
import 'package:crowdleague/actions/navigation/store_nav_bar_selection.dart';
import 'package:crowdleague/actions/problems/display_problem.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app/app_state.dart';

/// Reducers specify how the application"s state changes in response to actions
/// sent to the store.
///
/// Each reducer returns a new [AppState].
final navigationReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, AddProblem>(_addProblem),
  TypedReducer<AppState, DisplayProblem>(_displayProblem),
  TypedReducer<AppState, RemoveProblem>(_removeProblem),
  TypedReducer<AppState, StoreNavBarSelection>(_storeNavBarSelection),
  TypedReducer<AppState, RecordAddedRouteInfo>(_addRouteInfo),
  TypedReducer<AppState, RecordRemovedRouteInfo>(_removeRouteInfo),
  TypedReducer<AppState, RecordReplacedRouteInfo>(_replaceRouteInfo),
];

AppState _addProblem(AppState state, AddProblem action) {
  return state.rebuild((b) => b..problems.add(action.problem));
}

AppState _displayProblem(AppState state, DisplayProblem action) {
  return state.rebuild((b) => b..displayedProblem.replace(action.problem));
}

/// Remove the problem from the list.
///
/// If the problem being removed was the one being displayed then we change the
/// app state to reflect there is no longer a problem being displayed.
AppState _removeProblem(AppState state, RemoveProblem action) {
  return state.rebuild((b) => b
    ..displayedProblem = (b.displayedProblem == action.problem.toBuilder())
        ? null
        : b.displayedProblem
    ..problems.remove(action.problem));
}

AppState _addRouteInfo(AppState state, RecordAddedRouteInfo action) {
  return state.rebuild((b) => b..routes.add(action.info));
}

AppState _removeRouteInfo(AppState state, RecordRemovedRouteInfo action) {
  return state.rebuild((b) => b..routes.remove(action.info));
}

AppState _replaceRouteInfo(AppState state, RecordReplacedRouteInfo action) {
  return state.rebuild((b) => b
    ..routes.remove(action.oldInfo)
    ..routes.add(action.newInfo));
}

AppState _storeNavBarSelection(AppState state, StoreNavBarSelection action) {
  return state.rebuild((b) => b..navBarSelection = action.selection);
}
