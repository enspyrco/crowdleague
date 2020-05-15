import 'package:crowdleague/actions/auth/sign_out_user.dart';
import 'package:crowdleague/widgets/more_options/dark_mode_toggle.dart';
import 'package:flutter/material.dart';

import 'package:crowdleague/extensions/extensions.dart';

class MoreOptionsPage extends StatelessWidget {
  const MoreOptionsPage();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: RaisedButton(
            child: Text('SIGN OUT'),
            onPressed: () {
              context.dispatch(SignOutUser());
            },
          ),
        ),
        DarkModeToggle(),
        MaterialButton(onPressed: null),
        MaterialButton(onPressed: null),
      ],
    );
  }
}
