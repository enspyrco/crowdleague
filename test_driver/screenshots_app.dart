import 'package:crowdleague/utils/redux_bundle.dart';
import 'package:crowdleague/utils/services_bundle.dart';
import 'package:crowdleague/widgets/crowd_league_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

import 'mocks/auth_service_mocks.dart';
import 'mocks/notifications_service_mocks.dart';

void main() {
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();

  // remove debug banner for screenshots
  WidgetsApp.debugAllowBannerOverride = false;

  final navKey = GlobalKey<NavigatorState>();

  final redux = ReduxBundle(
      services: ServicesBundle(
          navKey: navKey,
          authService: FakeAuthService(),
          notificationsService: FakeNotificationsService()));

  runApp(CrowdLeagueApp(redux.store, navKey));
}
