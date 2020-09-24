import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/widgets/crowd_league_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:redux/redux.dart';
import 'package:redux_remote_devtools/redux_remote_devtools.dart';

Future<void> main() async {
  enableFlutterDriverExtension();

  // if in RDT mode, create a RemoteDevToolsMiddleware
  final _remoteDevtools = RemoteDevToolsMiddleware<dynamic>('localhost:8000');
  final _bucketName = 'gs://profile-pics-prototyping';

  // give RDT access to the store
  // _remoteDevtools.store = _store;

  await _remoteDevtools.connect();

  FirebaseFirestore.instance.settings = Settings(
      host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);

  runApp(CrowdLeagueApp());
}

class MiddlewareAddOn {
  Middleware middleware;
  Future<void> Function(Store<AppState> store) addOnFunction;
}
