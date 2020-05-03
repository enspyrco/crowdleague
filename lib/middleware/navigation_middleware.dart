import 'package:crowdleague/models/actions/add_problem.dart';
import 'package:crowdleague/models/actions/navigation/navigate_to.dart';
import 'package:crowdleague/models/actions/navigation/navigator_pop_all.dart';
import 'package:crowdleague/models/actions/remove_problem.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app/app_state.dart';

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
    TypedMiddleware<AppState, NavigatorPopAll>(
      _navigatorPopAll(navigationService),
    ),
    TypedMiddleware<AppState, AddProblem>(
      _displayProblem(navigationService),
    ),
  ];
}

void Function(Store<AppState> store, NavigateTo action, NextDispatcher next)
    _navigateTo(NavigationService navigationService) {
  return (Store<AppState> store, NavigateTo action, NextDispatcher next) async {
    next(action);

    //
    navigationService.navigateTo(action.location);
  };
}

void Function(
        Store<AppState> store, NavigatorPopAll action, NextDispatcher next)
    _navigatorPopAll(NavigationService navigationService) {
  return (Store<AppState> store, NavigatorPopAll action,
      NextDispatcher next) async {
    next(action);

    //
    navigationService.popHome();
  };
}

void Function(Store<AppState> store, AddProblem action, NextDispatcher next)
    _displayProblem(NavigationService navigationService) {
  return (Store<AppState> store, AddProblem action, NextDispatcher next) async {
    next(action); // add the problem to the store

    // display the problem then remove from store when alert is dismissed
    final problem = await navigationService.display(action.problem);
    store.dispatch(RemoveProblem((b) => b..problem = problem.toBuilder()));
  };
}
