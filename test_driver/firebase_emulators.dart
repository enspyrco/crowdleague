import 'package:crowdleague/utils/redux_bundle.dart';
import 'package:crowdleague/utils/services_bundle.dart';
import 'package:crowdleague/widgets/crowd_league_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

import 'mocks/storage_service_mocks.dart';

Future<void> main() async {
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();

  final navKey = GlobalKey<NavigatorState>();

  final redux = ReduxBundle(
      services:
          ServicesBundle(navKey: navKey, storageService: FakeStorageService()));

  // Fire up the app
  runApp(CrowdLeagueApp(redux.store, navKey));
}
