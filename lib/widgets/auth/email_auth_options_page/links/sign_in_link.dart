import 'package:crowdleague/actions/auth/update_email_auth_options_page.dart';
import 'package:crowdleague/enums/auto_validate.dart';
import 'package:crowdleague/enums/email_auth_mode.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:flutter/material.dart';

class SignInLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Text('SIGN IN',
            style: TextStyle(
                fontSize: 15,
                decoration: TextDecoration.underline,
                color: Colors.blue)),
        onTap: () {
          Form.of(context).reset();
          context.dispatch(UpdateEmailAuthOptionsPage(
            mode: EmailAuthMode.signIn,
            email: '',
            password: '',
            repeatPassword: '',
            autovalidate: AutoValidate.disabled,
          ));
        });
  }
}
