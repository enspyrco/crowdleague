import 'dart:io';

import 'package:crowdleague/middleware/middleware.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:crowdleague/utils/rdt_ips.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:crowdleague/models/app_state.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:crowdleague/utils/apple_signin_object.dart';
import 'package:crowdleague/app/app.dart';
import 'package:redux/redux.dart';
import 'package:redux_remote_devtools/redux_remote_devtools.dart';

void main() async {
  final remoteDevtools = RemoteDevToolsMiddleware(imac22);

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.init(),
    middleware: [
      remoteDevtools,
      ...createMiddleware(
        authService: AuthService(
          FirebaseAuth.instance,
          GoogleSignIn(scopes: <String>['email']),
          AppleSignInObject(),
        ),
      ),
    ],
  );

  remoteDevtools.store = store;

  try {
    await remoteDevtools.connect();
  } on SocketException catch (e) {
    print(e);
  }

  runApp(CrowdLeagueApp(store));
}
