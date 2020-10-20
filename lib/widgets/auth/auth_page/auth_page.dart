import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/widgets/auth/auth_page/buttons/auth_buttons.dart';
import 'package:crowdleague/widgets/auth/auth_page/static_elements/crowd_league_logo.dart';
import 'package:crowdleague/widgets/auth/auth_page/static_elements/explanation_text.dart';
import 'package:crowdleague/widgets/auth/auth_page/static_elements/tag_line_text.dart';
import 'package:crowdleague/widgets/shared/waiting_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool supportsAppleSignIn = true;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: StoreConnector<AppState, AuthStep>(
            distinct: true,
            converter: (store) => store.state.authPage.step,
            builder: (context, step) {
              switch (step) {
                case AuthStep.waitingForInput:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ExplanationText(),
                      CrowdLeagueLogo(),
                      TaglineText(),
                      AuthButtons(),
                    ],
                  );
                case AuthStep.signingInWithApple:
                  return WaitingIndicator('Contacting Apple...');
                case AuthStep.signingInWithGoogle:
                  return WaitingIndicator('Contacting Google...');
                case AuthStep.signingInWithEmail:
                  return WaitingIndicator('Signing In With Email...');
                case AuthStep.signingUpWithEmail:
                  return WaitingIndicator('Signing Up With Email...');
                case AuthStep.signingInWithFirebase:
                  return WaitingIndicator('Signing in with Firebase...');
                default:
                  return WaitingIndicator('Auth Step was null... huh?');
              }
            }));
  }
}
