import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/middleware/app_middleware.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:crowdleague/services/device_service.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:crowdleague/services/notifications_service.dart';
import 'package:crowdleague/utils/apple_signin_object.dart';
import 'package:crowdleague/widgets/crowd_league_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

import 'mocks/storage_service_mocks.dart';

Future<void> main() async {
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();

  await Firestore.instance.settings(
    host: 'localhost:8081',
    sslEnabled: false,
    persistenceEnabled: false,
  );

  /// we use a [GlobalKey] to allow navigation from a service
  /// ie. without a [BuildContext])
  ///
  /// The [GlobalKey] is created here and passed to the [NavigationService] as
  /// well as passed in to the [CrowdLeagueApp] widget so it can be used by the
  /// [MaterialApp] widget
  final navKey = GlobalKey<NavigatorState>();

  // Create services
  final authService = AuthService(
    FirebaseAuth.instance,
    GoogleSignIn(scopes: <String>['email']),
    AppleSignInObject(),
  );
  final navigationService = NavigationService(navKey);
  final databaseService = DatabaseService(Firestore.instance);
  final notificationsService = NotificationsService(FirebaseMessaging());
  final storageService = FakeStorageService();
  final deviceService = DeviceService(imagePicker: ImagePicker());

  // Create the redux store
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.init(),
    middleware: [
      ...createAppMiddleware(
          authService: authService,
          navigationService: navigationService,
          databaseService: databaseService,
          notificationsService: notificationsService,
          storageService: storageService,
          deviceService: deviceService),
    ],
  );

  // Fire up the app
  runApp(CrowdLeagueApp(store, navKey));
}
