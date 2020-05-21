import 'package:crowdleague/middleware/auth_middleware.dart';
import 'package:crowdleague/middleware/conversations_middleware.dart';
import 'package:crowdleague/middleware/device_middleware.dart';
import 'package:crowdleague/middleware/navigation_middleware.dart';
import 'package:crowdleague/middleware/notifications_middleware.dart';
import 'package:crowdleague/actions/meta/bundle_of_actions.dart';
import 'package:crowdleague/middleware/profile_middleware.dart';
import 'package:crowdleague/middleware/storage_middleware.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:crowdleague/services/device_service.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:crowdleague/services/notifications_service.dart';
import 'package:crowdleague/services/storage_service.dart';
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
    NavigationService navigationService,
    DatabaseService databaseService,
    NotificationsService notificationsService,
    StorageService storageService,
    DeviceService deviceService}) {
  return [
    TypedMiddleware<AppState, BundleOfActions>(
      _unwrapBundleOfActions(),
    ),
    ...createAuthMiddleware(authService: authService),
    ...createNavigationMiddleware(navigationService: navigationService),
    ...createConversationsMiddleware(databaseService: databaseService),
    ...createNotificationsMiddleware(
      notificationsService: notificationsService,
    ),
    ...createStorageMiddleware(storageService: storageService),
    ...createDeviceMiddleware(deviceService: deviceService),
    ...createProfileMiddleware(databaseService: databaseService),
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
