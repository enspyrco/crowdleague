import 'package:crowdleague/middleware/app_middleware.dart';
import 'package:crowdleague/middleware/auth_middleware.dart';
import 'package:crowdleague/middleware/navigation_middleware.dart';
import 'package:crowdleague/middleware/notifications_middleware.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:crowdleague/widgets/crowd_league_app.dart';
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
      LoggingMiddleware<dynamic>.printer(),
      ...createAppMiddleware(),
      ...createAuthMiddleware(authService: FakeAuthService()),
      ...createNavigationMiddleware(
          navigationService: NavigationService(navKey)),
      ...createNotificationsMiddleware(
          notificationsService: FakeNotificationsService()),
    ],
  );

  runApp(CrowdLeagueApp(store, navKey));
}
