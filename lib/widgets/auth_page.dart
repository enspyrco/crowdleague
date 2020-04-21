import 'dart:io';

import 'package:flutter/material.dart' hide Action;
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:crowdleague/models/actions/sign_in_with_apple.dart';
import 'package:crowdleague/models/actions/sign_in_with_google.dart';
import 'package:crowdleague/models/app_state.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool supportsAppleSignIn = true;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, int>(
        distinct: true,
        converter: (store) => store.state.authStep,
        builder: (context, authState) {
          return Material(
            child: IndexedStack(
              alignment: Alignment.center,
              index: authState,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'CROWDLEAGUE',
                      style: TextStyle(fontSize: 40),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'A PLATFORM',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'FOR CROWD SOURCING',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'SPORTS LEAGUES',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 50),
                    CrowdLeagueLogo(),
                    SizedBox(height: 50),
                    Text(
                      'BE IN A LEAGUE',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'OF YOUR OWN',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 100),
                    PlatformSignInButton(),
                    SizedBox(height: 20),
                    OtherOptionsButton(),
                  ],
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Text('Contacting Auth Provider...')
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Text('Signing in with Firebase...')
                    ]),
              ],
            ),
          );
        });
  }
}

class CrowdLeagueLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage('assets/images/logo-300-greyscale.png'),
      colorBlendMode: BlendMode.darken,
      width: 150,
      height: 150,
    );
  }
}

class PlatformSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (Platform.isIOS || Platform.isMacOS)
        ? AppleSignInButton(
            style: AppleButtonStyle.black,
            onPressed: () => StoreProvider.of<AppState>(context).dispatch(
              SignInWithApple(),
            ),
          )
        : GoogleSignInButton(
            onPressed: () => StoreProvider.of<AppState>(context)
                .dispatch(SignInWithGoogle()),
            darkMode: true, // default: false
          );
  }
}

class OtherOptionsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 40.0,
      padding: EdgeInsets.only(left: 30.0, right: 30.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
        side: BorderSide(
          color: Colors.black,
        ),
      ),
      child: RaisedButton(
        onPressed: () {},
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Other Sign in Options',
              style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: "SF Pro",
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
