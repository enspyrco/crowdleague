import 'package:crowdleague/enums/email_auth_mode.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/links/create_account_link.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/links/sign_in_link.dart';
import 'package:flutter/material.dart';

class SwitchModeText extends StatelessWidget {
  final EmailAuthMode mode;

  SwitchModeText(this.mode);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        if (mode == EmailAuthMode.signIn)
          (Text('DON\'T HAVE AN ACCOUNT?', style: TextStyle(fontSize: 15))),
        if (mode == EmailAuthMode.signUp)
          (Text('ALREADY HAVE AN ACCOUNT?', style: TextStyle(fontSize: 15))),
        SizedBox(height: 15),
        if (mode == EmailAuthMode.signIn) CreateAccountLink(),
        if (mode == EmailAuthMode.signUp) SignInLink()
      ],
    );
  }
}
