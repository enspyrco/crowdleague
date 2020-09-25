import 'package:crowdleague/actions/auth/sign_out_user.dart';
import 'package:crowdleague/actions/themes/store_theme_colors.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/themes/theme_colors.dart';
import 'package:crowdleague/widgets/more_options/dark_mode_toggle.dart';
import 'package:flutter/material.dart';

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
        MaterialButton(
            color: Colors.red,
            onPressed: () {
              context
                  .dispatch(StoreThemeColors(colors: ThemeColors.crowdleague));
            }),
        MaterialButton(
            color: Colors.grey,
            onPressed: () {
              context.dispatch(StoreThemeColors(colors: ThemeColors.greyscale));
            }),
      ],
    );
  }
}
