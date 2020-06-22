import 'package:crowdleague/actions/navigation/record_added_route_info.dart';
import 'package:crowdleague/actions/navigation/record_removed_route_info.dart';
import 'package:crowdleague/actions/navigation/record_replaced_route_info.dart';
import 'package:crowdleague/actions/navigation/store_nav_bar_selection.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app/app_state.dart';

/// Reducers specify how the application"s state changes in response to actions
/// sent to the store.
///
/// Each reducer returns a new [AppState].
final navigationReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, StoreNavBarSelection>(_storeNavBarSelection),
  TypedReducer<AppState, RecordAddedRouteInfo>(_addRouteInfo),
  TypedReducer<AppState, RecordRemovedRouteInfo>(_removeRouteInfo),
  TypedReducer<AppState, RecordReplacedRouteInfo>(_replaceRouteInfo),
];

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
