import 'dart:io';

import 'package:crowdleague/models/actions/sign_in_with_apple.dart';
import 'package:crowdleague/models/actions/sign_in_with_google.dart';
import 'package:crowdleague/models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_redux/flutter_redux.dart';

class OtherAuthOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [EmailSignInChip(true), EmailSignUpChip(false)],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: 'Email',
                ),
              ),
            ),
            SizedBox(height: 20),
            OtherPlatformSignInButton()
          ],
        ),
      ),
    );
  }
}

class OtherPlatformSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (Platform.isIOS || Platform.isMacOS)
        ? GoogleSignInButton(
            onPressed: () => StoreProvider.of<AppState>(context)
                .dispatch(SignInWithGoogle()),
            darkMode: true, // default: false
          )
        : AppleSignInButton(
            style: AppleButtonStyle.black,
            onPressed: () => StoreProvider.of<AppState>(context).dispatch(
              SignInWithApple(),
            ),
          );
  }
}

class EmailSignInChip extends StatelessWidget {
  final bool _selected;

  EmailSignInChip(this._selected);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
        label: Text('SIGN IN WITH EMAIL'),
        selected: _selected,
        onSelected: (bool selected) {});
  }
}

class EmailSignUpChip extends StatelessWidget {
  final bool _selected;

  EmailSignUpChip(this._selected);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
        label: Text('CREATE AN ACCOUNT'),
        selected: _selected,
        onSelected: (bool selected) {});
  }
}
