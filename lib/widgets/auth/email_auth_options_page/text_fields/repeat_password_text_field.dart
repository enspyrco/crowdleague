import 'package:crowdleague/actions/auth/update_email_auth_options_page.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/utils/form_validation.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/buttons/password_suffix_icon_button.dart';
import 'package:flutter/material.dart';

class RepeatPasswordTextField extends StatelessWidget {
  final bool visible;
  final String password;
  final AutovalidateMode autovalidateMode;

  const RepeatPasswordTextField({
    Key key,
    @required this.visible,
    @required this.password,
    @required this.autovalidateMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: TextFormField(
        validator: (value) => (value.isEmpty)
            ? 'please enter password again'
            : (!validRepeatPassword(value, password))
                ? 'passwords do not match'
                : null,
        obscureText: !visible,
        autovalidateMode: autovalidateMode,
        onChanged: (value) =>
            context.dispatch(UpdateEmailAuthOptionsPage(repeatPassword: value)),
        decoration: InputDecoration(
          suffixIcon: PasswordSuffixIconButton(visible: visible),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Colors.red)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Colors.green)),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: 'Repeat Password',
        ),
      ),
    );
  }
}
