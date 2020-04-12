import 'package:crowdleague/middleware/middleware.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:crowdleague/models/app_state.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:crowdleague/utils/apple_signin_object.dart';
import 'package:crowdleague/app/app.dart';
import 'package:redux/redux.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];

    print(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];

    print(notification);
  }

  return null;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print('onMessage: $message');
      // _showItemDialog(message);
    },
    onBackgroundMessage: backgroundMessageHandler,
    onLaunch: (Map<String, dynamic> message) async {
      print('onLaunch: $message');
      // _navigateToItemDetail(message);
    },
    onResume: (Map<String, dynamic> message) async {
      print('onResume: $message');
      // _navigateToItemDetail(message);
    },
  );

  _firebaseMessaging.requestNotificationPermissions();

  _firebaseMessaging.getToken().then(print);

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.init(),
    middleware: [
      ...createMiddleware(
        authService: AuthService(
          FirebaseAuth.instance,
          GoogleSignIn(scopes: <String>['email']),
          AppleSignInObject(),
        ),
      ),
    ],
  );

  runApp(CrowdLeagueApp(store));
}
