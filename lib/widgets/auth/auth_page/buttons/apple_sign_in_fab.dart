import 'package:crowdleague/actions/auth/sign_in_with_apple.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:flutter/material.dart';

class AppleSignInFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: ImageIcon(AssetImage('assets/images/apple_logo_black.png')),
        elevation: 1,
        mini: true,
        onPressed: () => context.dispatch(SignInWithApple()));
  }
}
