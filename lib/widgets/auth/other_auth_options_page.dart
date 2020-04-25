import 'dart:io';

import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/actions/set_email_auth_mode.dart';
import 'package:crowdleague/models/actions/set_password_visibility.dart';
import 'package:crowdleague/models/actions/sign_in_with_google.dart';
import 'package:crowdleague/models/app_state.dart';
import 'package:crowdleague/models/enums/email_auth_mode.dart';
import 'package:crowdleague/models/other_auth_options_view_model.dart';
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
        body: StoreConnector<AppState, OtherAuthOptionsViewModel>(
          distinct: true,
          converter: (store) => store.state.otherAuthOptions,
          builder: (context, vm) {
            return Center(
              child: Column(
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            EmailSignInChip(vm.mode == EmailAuthMode.signIn),
                            EmailSignUpChip(vm.mode == EmailAuthMode.signUp)
                          ],
                        ),
                        SizedBox(height: 20),
                        EmailTextField(),
                        SizedBox(height: 20),
                        PasswordTextField(
                          visible: vm.passwordVisible,
                        ),
                        SizedBox(height: 20),
                        if (vm.mode == EmailAuthMode.signUp)
                          RepeatPasswordTextField(
                            visible: vm.passwordVisible,
                          ),
                        if (vm.mode == EmailAuthMode.signUp)
                          SizedBox(height: 50),
                        IndexedStack(
                          index: vm.mode.index,
                          children: [
                            Center(child: SignInButton()),
                            Center(child: CreateAccountButton()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                  )
                ],
              ),
            );
          },
        ));
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
  final bool visible;

  const PasswordTextField({
    Key key,
    this.visible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: TextField(
        obscureText: !visible,
        decoration: InputDecoration(
          suffixIcon: PasswordSuffixIconButton(
            visible: visible,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: 'Password',
        ),
      ),
    );
  }
}

class RepeatPasswordTextField extends StatelessWidget {
  final bool visible;

  const RepeatPasswordTextField({
    Key key,
    this.visible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: TextField(
        obscureText: !visible,
        decoration: InputDecoration(
          suffixIcon: PasswordSuffixIconButton(
            visible: visible,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: 'Repeat Password',
        ),
      ),
    );
  }
}

class PasswordSuffixIconButton extends StatelessWidget {
  final bool visible;

  const PasswordSuffixIconButton({Key key, this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 12.0),
      child: IconButton(
        icon: (visible) ? Icon(Icons.close) : Icon(Icons.remove_red_eye),
        onPressed: () {
          context.dispatch(SetPasswordVisibility((b) => b..visible = !visible));
        },
      ),
    );
  }
}

class OtherPlatformSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (Platform.isIOS || Platform.isMacOS)
        ? GoogleSignInButton(
            onPressed: () => context.dispatch(SignInWithGoogle()),
            darkMode: true, // default: false
          )
        : AppleSignInButton(
            style: AppleButtonStyle.black,
            onPressed: () {
              _notImplemented(context);
            });
  }

  Future<void> _notImplemented(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Not ready yet"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Sorry! This hasn't been implemented yet."),
                Text("If you have previously signed in on iOS you could link"),
                Text("your google account there then use Google Sign In here."),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
        onSelected: (bool selected) {
          context.dispatch(
              SetEmailAuthMode((b) => b..mode = EmailAuthMode.signIn));
        });
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
        onSelected: (bool selected) {
          context.dispatch(
              SetEmailAuthMode((b) => b..mode = EmailAuthMode.signUp));
        });
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
