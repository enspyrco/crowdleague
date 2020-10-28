import 'package:crowdleague/actions/auth/sign_in_with_apple.dart';
import 'package:crowdleague/actions/auth/sign_in_with_google.dart';
import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/widgets/auth/auth_page/buttons/apple_sign_in_button.dart';
import 'package:crowdleague/widgets/auth/auth_page/buttons/google_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
                onPressed: () => context.dispatch(SignInWithApple()),
              )
            : GoogleSignInButton(
                onPressed: () => context.dispatch(SignInWithGoogle()),
                darkMode: true, // default: false
              );
      },
    );
  }
}
