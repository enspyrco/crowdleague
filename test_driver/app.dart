import 'package:crowdleague/app/app.dart';
import 'package:crowdleague/middleware/middleware.dart';
import 'package:crowdleague/models/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:redux/redux.dart';

void main() {
  enableFlutterDriverExtension();

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
