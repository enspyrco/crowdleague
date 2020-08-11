import 'package:crowdleague/utils/redux_bundle.dart';
import 'package:crowdleague/utils/services_bundle.dart';
import 'package:crowdleague/widgets/crowd_league_app.dart';
import 'package:flutter/material.dart';

void main() async {
  // Wait for the engine to bind with the framework
  WidgetsFlutterBinding.ensureInitialized();

  // A GlobalKey that allows the NavigationService to navigate,
  // must be used when creating the MaterialApp widget
  final navKey = GlobalKey<NavigatorState>();

  // The services, bundled together
  final services = ServicesBundle(navKey: navKey);

  // A bundle of redux stuff (services, middleware, store)
  final redux = await ReduxBundle.create(services);

  // Fire up the app
  runApp(CrowdLeagueApp(redux.store, navKey));
}
