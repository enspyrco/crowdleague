import 'package:crowdleague/actions/auth/update_email_auth_options_page.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/utils/form_validation.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/buttons/password_suffix_icon_button.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  final bool visible;
  final AutovalidateMode autovalidateMode;

  const PasswordTextField({
    Key key,
    @required this.visible,
    @required this.autovalidateMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: TextFormField(
        validator: (value) => (value.isEmpty)
            ? 'please enter password'
            : (!validPassword(value))
                ? 'password must be between 6 and 30 characters'
                : null,
        autovalidateMode: autovalidateMode,
        obscureText: !visible,
        onChanged: (value) =>
            context.dispatch(UpdateEmailAuthOptionsPage(password: value)),
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
