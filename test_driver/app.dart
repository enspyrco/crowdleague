import 'package:crowdleague/app/app.dart';
import 'package:crowdleague/middleware/middleware.dart';
import 'package:crowdleague/middleware/navigation_middleware.dart';
import 'package:crowdleague/models/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';

import 'mocks/auth_service_mocks.dart';
import 'mocks/notifications_service_mocks.dart';

void main() {
  WidgetsApp.debugAllowBannerOverride =
      false; // remove debug banner for screenshots
  enableFlutterDriverExtension();

  final navKey = GlobalKey<NavigatorState>();

  // create the store with mocked out service members to give fast and
  // consistent responses
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.init(),
    middleware: [
      ...createNavigationMiddleware(
          navigationService: NavigationService(navKey)),
      ...createMiddleware(
          authService: FakeAuthService(),
          notificationsService: FakeNotificationsService()),
      LoggingMiddleware.printer(),
    ],
  );

  runApp(CrowdLeagueApp(store, navKey));
}
