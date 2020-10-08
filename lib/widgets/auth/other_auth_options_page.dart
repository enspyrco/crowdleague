import 'package:crowdleague/actions/auth/sign_in_with_apple.dart';
import 'package:crowdleague/actions/auth/sign_in_with_google.dart';
import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_redux/flutter_redux.dart';

class OtherAuthOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        body: AuthProviderOptions());
  }
}

class AuthProviderOptions extends StatelessWidget {
  const AuthProviderOptions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [SizedBox(height: 20), OtherPlatformSignInButton()],
    ));
  }
}

class OtherPlatformSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PlatformType>(
        distinct: true,
        converter: (store) => store.state.systemInfo.platform,
        builder: (context, platform) {
          return (platform == PlatformType.ios ||
                  platform == PlatformType.macOS)
              ? GoogleSignInButton(
                  onPressed: () => context.dispatch(SignInWithGoogle()),
                  darkMode: true, // default: false
                )
              : AppleSignInButton(
                  style: AppleButtonStyle.black,
                  onPressed: () => context.dispatch(
                    SignInWithApple(),
                  ),
                );
        });
  }
}
