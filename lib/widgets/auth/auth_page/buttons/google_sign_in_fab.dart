import 'package:crowdleague/actions/auth/sign_in_with_google.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:flutter/material.dart';

class GoogleSignInFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: ImageIcon(AssetImage('assets/images/google_logo.png')),
        elevation: 1,
        mini: true,
        onPressed: () => context.dispatch(SignInWithGoogle()));
  }
}
