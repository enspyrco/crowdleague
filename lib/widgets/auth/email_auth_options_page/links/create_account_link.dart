import 'package:crowdleague/actions/auth/update_email_auth_options_page.dart';
import 'package:crowdleague/enums/auth/email_auth_mode.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:flutter/material.dart';

class CreateAccountLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Text('CREATE ACCOUNT',
            style: TextStyle(
                fontSize: 15,
                decoration: TextDecoration.underline,
                color: Colors.blue)),
        onTap: () {
          context
              .dispatch(UpdateEmailAuthOptionsPage(mode: EmailAuthMode.signUp));
        });
  }
}
