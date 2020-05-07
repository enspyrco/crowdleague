import 'package:crowdleague/models/actions/notifications/print_fcm_token.dart';
import 'package:crowdleague/models/actions/notifications/request_fcm_permissions.dart';
import 'package:crowdleague/services/notifications_service.dart';
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
List<Middleware<AppState>> createNotificationsMiddleware(
    {NotificationsService notificationsService}) {
  return [
    TypedMiddleware<AppState, RequestFCMPermissions>(
      _requestNotificationPermissions(notificationsService),
    ),
    TypedMiddleware<AppState, PrintFCMToken>(
      _printFCMToken(notificationsService),
    ),
  ];
}

void Function(Store<AppState> store, RequestFCMPermissions action,
        NextDispatcher next)
    _requestNotificationPermissions(NotificationsService notificationsService) {
  return (Store<AppState> store, RequestFCMPermissions action,
      NextDispatcher next) async {
    next(action);

    notificationsService.requestPermissions();
  };
}

void Function(Store<AppState> store, PrintFCMToken action, NextDispatcher next)
    _printFCMToken(NotificationsService notificationsService) {
  return (Store<AppState> store, PrintFCMToken action,
      NextDispatcher next) async {
    next(action);

    notificationsService.printToken();
  };
}
