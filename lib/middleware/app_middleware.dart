import 'package:crowdleague/actions/database/plumb_database_stream.dart';
import 'package:crowdleague/actions/problems/add_problem.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/middleware/auth_middleware.dart';
import 'package:crowdleague/middleware/conversations_middleware.dart';
import 'package:crowdleague/middleware/leaguers_middleware.dart';
import 'package:crowdleague/middleware/navigation_middleware.dart';
import 'package:crowdleague/middleware/notifications_middleware.dart';
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
    ...createAuthMiddleware(authService: authService),
    ...createNavigationMiddleware(navigationService: navigationService),
    ...createLeaguersMiddleware(databaseService: databaseService),
    ...createConversationsMiddleware(databaseService: databaseService),
    ...createNotificationsMiddleware(
      notificationsService: notificationsService,
    ),
    ...createProfileMiddleware(
        databaseService: databaseService,
        deviceService: deviceService,
        storageService: storageService,
        navigationService: navigationService),
    ...createStorageMiddleware(
        storageService: storageService, navigationService: navigationService),
    TypedMiddleware<AppState, PlumbDatabaseStream>(
      _plumbDatabaseStream(databaseService),
    ),
  ];
}

void Function(
        Store<AppState> store, PlumbDatabaseStream action, NextDispatcher next)
    _plumbDatabaseStream(DatabaseService databaseService) {
  return (Store<AppState> store, PlumbDatabaseStream action,
      NextDispatcher next) async {
    next(action);

    databaseService.storeStream.listen(
      store.dispatch,
      onError: (dynamic error, StackTrace trace) => store.dispatch(
        AddProblem.from(
            message: error.toString(),
            traceString: trace.toString(),
            type: ProblemType.databaseStoreController),
      ),
    );
  };
}
