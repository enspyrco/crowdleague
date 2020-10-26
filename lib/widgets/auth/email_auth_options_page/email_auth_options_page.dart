import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/enums/email_auth_mode.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/auth/vm_email_auth_options_page.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/buttons/create_account_button.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/buttons/sign_in_button.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/text/switch_mode_text.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/text_fields/email_text_field.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/text_fields/password_text_field.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/text_fields/repeat_password_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class EmailAuthOptionsPage extends StatelessWidget {
  const EmailAuthOptionsPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: StoreConnector<AppState, VmEmailAuthOptionsPage>(
        distinct: true,
        converter: (store) => store.state.emailAuthOptionsPage,
        builder: (context, vm) {
          if (vm.step != AuthStep.waitingForInput) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            // this padding provides some space when the keyboard comes up
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    EmailTextField(
                        autovalidateMode: vm.autovalidate.toAutovalidateMode()),
                    SizedBox(height: 20),
                    PasswordTextField(
                        visible: vm.showPassword,
                        autovalidateMode: vm.autovalidate.toAutovalidateMode()),
                    SizedBox(height: 20),
                    if (vm.mode == EmailAuthMode.signUp)
                      RepeatPasswordTextField(
                          visible: vm.showPassword,
                          password: vm.password,
                          autovalidateMode:
                              vm.autovalidate.toAutovalidateMode()),
                    SizedBox(height: 30),
                    if (vm.mode == EmailAuthMode.signIn) SignInButton(),
                    if (vm.mode == EmailAuthMode.signUp) CreateAccountButton(),
                    SwitchModeText(vm.mode)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
