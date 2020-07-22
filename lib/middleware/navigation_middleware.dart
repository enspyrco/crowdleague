import 'package:crowdleague/actions/navigation/navigate_to.dart';
import 'package:crowdleague/actions/navigation/navigator_pop_all.dart';
import 'package:crowdleague/actions/navigation/navigator_replace_current.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app/app_state.dart';

typedef NavigateToMiddleware = void Function(
    Store<AppState> store, NavigateTo action, NextDispatcher next);
typedef NavigatorReplaceCurrentMiddleware = void Function(
    Store<AppState> store, NavigatorReplaceCurrent action, NextDispatcher next);
typedef NavigatorPopAllMiddleware = void Function(
    Store<AppState> store, NavigatorPopAll action, NextDispatcher next);

/// Middleware is used for a variety of things:
/// - Logging
/// - Async calls (database, network)
/// - Calling to system frameworks
///
/// These are performed when actions are dispatched to the Store
///
/// The output of an action can perform another action using the [NextDispatcher]
///
List<Middleware<AppState>> createNavigationMiddleware(
    {NavigationService navigationService}) {
  return [
    TypedMiddleware<AppState, NavigateTo>(
      _navigateTo(navigationService),
    ),
    TypedMiddleware<AppState, NavigatorReplaceCurrent>(
      _navigatorReplaceCurrent(navigationService),
    ),
    TypedMiddleware<AppState, NavigatorPopAll>(
      _navigatorPopAll(navigationService),
    ),
  ];
}

/// [NavigateTo]
NavigateToMiddleware _navigateTo(NavigationService navigationService) =>
    (store, action, next) async {
      next(action);

      navigationService.navigateTo(action.location);
    };

/// [NavigatorReplaceCurrent]
NavigatorReplaceCurrentMiddleware _navigatorReplaceCurrent(
        NavigationService navigationService) =>
    (store, action, next) async {
      next(action);

      navigationService.replaceCurrentWith(action.newLocation);
    };

/// [NavigatorPopAll]
NavigatorPopAllMiddleware _navigatorPopAll(
        NavigationService navigationService) =>
    (store, action, next) async {
      next(action);

      navigationService.popHome();
    };
