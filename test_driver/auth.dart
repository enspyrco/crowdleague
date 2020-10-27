import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/utils/redux/redux_bundle.dart';
import 'package:crowdleague/widgets/app/crowd_league_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

import 'mocks/services/auth_service_mocks.dart';
import 'mocks/services/database_service_mocks.dart';
import 'mocks/services/notifications_service_mocks.dart';
import 'mocks/services/storage_service_mocks.dart';

void main() {
  enableFlutterDriverExtension();

  // Settings to make the firestore package use the local emulator
  final _firestoreSettings = Settings(
      host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);

  // Setup the services bundle to use a different bucket and with an extra
  // middleware that sends each action and state to the rdt server for display.
  ReduxBundle.setup(
      bucketName: 'gs://profile-pics-prototyping',
      firestoreSettings: _firestoreSettings);

  // create a fake redux bundle
  final redux = ReduxBundle(
      notificationsService: FakeNotificationsService(),
      authService: FakeAuthService(),
      databaseService: FakeDatabaseService(),
      storageService: FakeStorageService(StreamController<ReduxAction>()));

  runApp(CrowdLeagueApp(redux: redux));
}
