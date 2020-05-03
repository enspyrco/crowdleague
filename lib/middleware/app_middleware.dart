import 'package:crowdleague/models/actions/bundle_of_actions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

/// Middleware is used for a variety of things:
/// - Logging
/// - Async calls (database, network)
/// - Calling to system frameworks
///
/// These are performed when actions are dispatched to the Store
///
/// The output of an action can perform another action using the [NextDispatcher]
///
List<Middleware<AppState>> createAppMiddleware() {
  return [
    TypedMiddleware<AppState, BundleOfActions>(
      _unwrapBundleOfActions(),
    ),
  ];
}

void Function(
        Store<AppState> store, BundleOfActions action, NextDispatcher next)
    _unwrapBundleOfActions() {
  return (Store<AppState> store, BundleOfActions action, NextDispatcher next) {
    next(action);
    action.actions.forEach(store.dispatch);
  };
}
