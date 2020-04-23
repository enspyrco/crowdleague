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
            EmailTextField(),
            SizedBox(height: 20),
            PasswordTextField(),
            SizedBox(height: 20),
            RepeatPasswordTextField(),
            SizedBox(height: 20),
            SignInButton(),
            CreateAccountButton(),
            SizedBox(height: 20),
            Divider(color: Colors.black),
            SizedBox(height: 50),
            Text(
              'OR',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 50),
            OtherPlatformSignInButton()
          ],
        ),
      ),
    );
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: 'Email',
        ),
      ),
    );
  }
}

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          suffixIcon: ShowTextSuffixIcon(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: 'Password',
        ),
      ),
    );
  }
}

class RepeatPasswordTextField extends StatelessWidget {
  const RepeatPasswordTextField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          suffixIcon: ShowTextSuffixIcon(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: 'Repeat Password',
        ),
      ),
    );
  }
}

class ShowTextSuffixIcon extends StatelessWidget {
  const ShowTextSuffixIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 12.0),
      child: Icon(Icons.remove_red_eye), // myIcon is a 48px-wide widget.
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

class SignInButton extends StatelessWidget {
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
              'SIGN IN',
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

class CreateAccountButton extends StatelessWidget {
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
              'CREATE ACCOUNT',
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
