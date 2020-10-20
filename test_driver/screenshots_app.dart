import 'package:crowdleague/widgets/app/crowd_league_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() {
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsApp.debugAllowBannerOverride = false;
  runApp(CrowdLeagueApp());
}
