import 'package:crowdleague/app/app.dart';
import 'package:crowdleague/middleware/app_middleware.dart';
import 'package:crowdleague/middleware/auth_middleware.dart';
import 'package:crowdleague/middleware/navigation_middleware.dart';
import 'package:crowdleague/middleware/notifications_middleware.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:crowdleague/services/notifications_service.dart';
import 'package:crowdleague/utils/apple_signin_object.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redux/redux.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// we use a [GlobalKey] to allow navigation from a service
  /// ie. without a [BuildContext])
  ///
  /// The [GlobalKey] is created here and passed to the [NavigationService] as
  /// well as passed in to the [CrowdLeagueApp] widget so it can be used by the
  /// [MaterialApp] widget
  final navKey = GlobalKey<NavigatorState>();

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.init(),
    middleware: [
      ...createAppMiddleware(),
      ...createAuthMiddleware(
          authService: AuthService(
        FirebaseAuth.instance,
        GoogleSignIn(scopes: <String>['email']),
        AppleSignInObject(),
      )),
      ...createNavigationMiddleware(
          navigationService: NavigationService(navKey)),
      ...createNotificationsMiddleware(
        notificationsService: NotificationsService(FirebaseMessaging()),
      ),
    ],
  );

  runApp(CrowdLeagueApp(store, navKey));
}
