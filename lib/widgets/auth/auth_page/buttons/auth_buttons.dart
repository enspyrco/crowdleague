import 'package:crowdleague/widgets/auth/auth_page/buttons/email_options_fab.dart';
import 'package:crowdleague/widgets/auth/auth_page/buttons/facebook_sign_in_fab.dart';
import 'package:crowdleague/widgets/auth/auth_page/buttons/other_provider_fab.dart';
import 'package:crowdleague/widgets/auth/auth_page/buttons/platform_sign_in_button.dart';
import 'package:crowdleague/widgets/auth/auth_page/buttons/twitter_sign_in_fab.dart';
import 'package:flutter/material.dart';

class AuthButtons extends StatelessWidget {
  const AuthButtons({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PlatformSignInButton(),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                EmailOptionsFAB(),
                OtherProviderFAB(),
                TwitterSignInFAB(),
                FacebookSignInFAB()
              ],
            ),
          ]),
    );
  }
}
