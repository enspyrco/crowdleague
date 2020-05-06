import 'package:crowdleague/middleware/auth_middleware.dart';
import 'package:crowdleague/middleware/leaguers_middleware.dart';
import 'package:crowdleague/middleware/navigation_middleware.dart';
import 'package:crowdleague/middleware/notifications_middleware.dart';
import 'package:crowdleague/models/actions/meta/bundle_of_actions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:crowdleague/services/leaguers_service.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:crowdleague/services/notifications_service.dart';
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
List<Middleware<AppState>> createAppMiddleware(
    {AuthService authService,
    LeaguersService leaguersService,
    NavigationService navigationService,
    NotificationsService notificationsService}) {
  return [
    TypedMiddleware<AppState, BundleOfActions>(
      _unwrapBundleOfActions(),
    ),
    ...createAuthMiddleware(authService: authService),
    ...createLeaguersMiddleware(leaguersService: leaguersService),
    ...createNavigationMiddleware(navigationService: navigationService),
    ...createNotificationsMiddleware(
      notificationsService: notificationsService,
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
