import 'package:crowdleague/actions/auth/sign_in_with_apple.dart';
import 'package:crowdleague/actions/auth/sign_in_with_google.dart';
import 'package:crowdleague/actions/navigation/navigate_to.dart';
import 'package:crowdleague/actions/navigation/push_page.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/navigation/page_data/email_auth_page_data.dart';
import 'package:crowdleague/widgets/shared/waiting_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
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
                  return PageContents();
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
                  return WaitingIndicator('Who the heck knows?');
              }
            }));
  }
}

class PageContents extends StatelessWidget {
  const PageContents({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ExplanationText(),
        CrowdLeagueLogo(),
        TaglineText(),
        Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PlatformSignInButton(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [EmailOptionsButton(), OtherOptionsButton()],
                ),
              ]),
        ),
      ],
    );
  }
}

class ExplanationText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
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

class TaglineText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'BE IN A LEAGUE',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'OF YOUR OWN',
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}

class PlatformSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PlatformType>(
      distinct: true,
      converter: (store) => store.state.systemInfo.platform,
      builder: (context, platform) {
        return (platform == PlatformType.ios || platform == PlatformType.macOS)
            ? AppleSignInButton(
                style: AppleButtonStyle.black,
                onPressed: () => context.dispatch(
                  SignInWithApple(),
                ),
              )
            : GoogleSignInButton(
                onPressed: () => context.dispatch(SignInWithGoogle()),
                darkMode: true, // default: false
              );
      },
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
        onPressed: () =>
            context.dispatch(NavigateTo(location: '/other_auth_options')),
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'More Options',
              style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class EmailOptionsButton extends StatelessWidget {
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
        onPressed: () => context.dispatch(PushPage(entry: EmailAuthPageData())),
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your Email',
              style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
