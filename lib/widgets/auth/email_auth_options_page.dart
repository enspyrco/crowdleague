import 'package:crowdleague/actions/auth/sign_in_with_email.dart';
import 'package:crowdleague/actions/auth/sign_up_with_email.dart';
import 'package:crowdleague/actions/auth/update_email_auth_options_page.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/enums/email_auth_mode.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/auth/vm_other_auth_options_page.dart';
import 'package:crowdleague/utils/form_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class EmailAuthOptionsPage extends StatelessWidget {
  const EmailAuthOptionsPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        body: StoreConnector<AppState, VmOtherAuthOptionsPage>(
          distinct: true,
          converter: (store) => store.state.otherAuthOptionsPage,
          builder: (context, vm) {
            if (vm.step != AuthStep.waitingForInput) {
              return Center(child: CircularProgressIndicator());
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              EmailSignInChip(vm.mode == EmailAuthMode.signIn),
                              EmailSignUpChip(vm.mode == EmailAuthMode.signUp)
                            ],
                          ),
                          SizedBox(height: 20),
                          EmailTextField(),
                          SizedBox(height: 20),
                          PasswordTextField(
                            visible: vm.showPassword,
                          ),
                          SizedBox(height: 20),
                          if (vm.mode == EmailAuthMode.signUp)
                            RepeatPasswordTextField(
                              visible: vm.showPassword,
                              password: vm.password,
                            ),
                          SizedBox(
                              height:
                                  50), // TODO: was commented out as hack to do widget test without overlay error
                          if (vm.mode == EmailAuthMode.signIn) SignInButton(),
                          if (vm.mode == EmailAuthMode.signUp)
                            CreateAccountButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            'please enter email';
          } else if (!validEmail(value)) {
            return 'please enter a valid email';
          }
          return null;
        },
        onChanged: (value) {
          context.dispatch(UpdateEmailAuthOptionsPage(email: value));
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

class PasswordTextField extends StatelessWidget {
  final bool visible;

  const PasswordTextField({
    Key key,
    this.visible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            'please enter password';
          } else if (!validPassword(value)) {
            return 'password must be between 6 and 30 characters';
          }
          return null;
        },
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

class RepeatPasswordTextField extends StatelessWidget {
  final bool visible;
  final String password;

  const RepeatPasswordTextField({
    Key key,
    this.visible,
    this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'please enter password';
          } else if (!validRepeatPassword(value, password)) {
            return 'passwords do not match';
          }
          return null;
        },
        obscureText: !visible,
        onChanged: (value) =>
            context.dispatch(UpdateEmailAuthOptionsPage(repeatPassword: value)),
        decoration: InputDecoration(
          suffixIcon: PasswordSuffixIconButton(
            visible: visible,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: 'Repeat Password',
        ),
      ),
    );
  }
}

class PasswordSuffixIconButton extends StatelessWidget {
  final bool visible;

  const PasswordSuffixIconButton({Key key, this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 12.0),
      child: IconButton(
        icon: (visible) ? Icon(Icons.close) : Icon(Icons.remove_red_eye),
        onPressed: () {
          context.dispatch(UpdateEmailAuthOptionsPage(showPassword: !visible));
        },
      ),
    );
  }
}

class EmailSignInChip extends StatelessWidget {
  final bool _selected;

  EmailSignInChip(this._selected);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
        label: Text('SIGN IN'),
        selected: _selected,
        onSelected: (bool selected) {
          Form.of(context).reset();
          context.dispatch(UpdateEmailAuthOptionsPage(
            mode: EmailAuthMode.signIn,
            email: '',
            password: '',
            repeatPassword: '',
          ));
        });
  }
}

class EmailSignUpChip extends StatelessWidget {
  final bool _selected;

  EmailSignUpChip(this._selected);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
        label: Text('CREATE'),
        selected: _selected,
        onSelected: (bool selected) {
          Form.of(context).reset();
          context.dispatch(UpdateEmailAuthOptionsPage(
            mode: EmailAuthMode.signUp,
            email: '',
            password: '',
            repeatPassword: '',
          ));
        });
  }
}

class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 40.0,
      padding: EdgeInsets.only(left: 30.0, right: 30.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
        side: BorderSide(
          color: Colors.black,
        ),
      ),
      child: RaisedButton(
        onPressed: () {
          if (Form.of(context).validate()) {
            context.dispatch(SignInWithEmail());
          }
        },
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SIGN IN',
              style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 40.0,
      padding: EdgeInsets.only(left: 30.0, right: 30.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
        side: BorderSide(
          color: Colors.black,
        ),
      ),
      child: RaisedButton(
        onPressed: () {
          if (Form.of(context).validate()) {
            context.dispatch(SignUpWithEmail());
          }
        },
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'CREATE ACCOUNT',
              style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
