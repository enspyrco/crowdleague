import 'package:crowdleague/middleware/middleware.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:crowdleague/models/app_state.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:crowdleague/utils/apple_signin_object.dart';
import 'package:crowdleague/app/app.dart';
import 'package:redux/redux.dart';

void main() async {
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
