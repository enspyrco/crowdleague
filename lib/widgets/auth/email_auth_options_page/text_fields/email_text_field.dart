import 'package:crowdleague/actions/auth/update_email_auth_options_page.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/utils/form_validation.dart';
import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  final AutovalidateMode autovalidateMode;

  const EmailTextField({
    Key key,
    @required this.autovalidateMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: TextFormField(
        validator: (value) => (value.isEmpty)
            ? 'please enter email'
            : (!validEmail(value))
                ? 'please enter a valid email'
                : null,
        autovalidateMode: autovalidateMode,
        onChanged: (value) {
          context.dispatch(UpdateEmailAuthOptionsPage(
            email: value,
          ));
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: 'Email',
        ),
      ),
    );
  }
}
