library update_email_auth_options_page;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/enums/auth/auth_step.dart';
import 'package:crowdleague/enums/auth/auto_validate.dart';
import 'package:crowdleague/enums/auth/email_auth_mode.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'update_email_auth_options_page.g.dart';

abstract class UpdateEmailAuthOptionsPage extends Object
    with ReduxAction
    implements
        Built<UpdateEmailAuthOptionsPage, UpdateEmailAuthOptionsPageBuilder> {
  @nullable
  EmailAuthMode get mode;
  @nullable
  AuthStep get step;
  @nullable
  bool get showPassword;
  @nullable
  String get email;
  @nullable
  String get password;
  @nullable
  String get repeatPassword;
  @nullable
  AutoValidate get autovalidate;

  UpdateEmailAuthOptionsPage._();

  factory UpdateEmailAuthOptionsPage({
    EmailAuthMode mode,
    AuthStep step,
    bool showPassword,
    String email,
    String password,
    String repeatPassword,
    AutoValidate autovalidate,
  }) = _$UpdateEmailAuthOptionsPage._;

  factory UpdateEmailAuthOptionsPage.by(
          [void Function(UpdateEmailAuthOptionsPageBuilder) updates]) =
      _$UpdateEmailAuthOptionsPage;

  Object toJson() =>
      serializers.serializeWith(UpdateEmailAuthOptionsPage.serializer, this);

  static UpdateEmailAuthOptionsPage fromJson(String jsonString) =>
      serializers.deserializeWith(
          UpdateEmailAuthOptionsPage.serializer, json.decode(jsonString));

  static Serializer<UpdateEmailAuthOptionsPage> get serializer =>
      _$updateEmailAuthOptionsPageSerializer;

  @override
  String toString() => 'UPDATE_EMAIL_AUTH_OPTIONS_PAGE';
}
