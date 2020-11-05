library vm_email_auth_options_page;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/enums/auth/auth_step.dart';
import 'package:crowdleague/enums/auth/auto_validate.dart';
import 'package:crowdleague/enums/auth/email_auth_mode.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'vm_email_auth_options_page.g.dart';

abstract class VmEmailAuthOptionsPage
    implements Built<VmEmailAuthOptionsPage, VmEmailAuthOptionsPageBuilder> {
  EmailAuthMode get mode;
  AuthStep get step;
  bool get showPassword;
  String get email;
  String get password;
  String get repeatPassword;
  AutoValidate get autovalidate;

  VmEmailAuthOptionsPage._();

  factory VmEmailAuthOptionsPage({
    @required EmailAuthMode mode,
    @required AuthStep step,
    @required bool showPassword,
    @required String email,
    @required String password,
    @required String repeatPassword,
    @required AutoValidate autovalidate,
  }) = _$VmEmailAuthOptionsPage._;

  factory VmEmailAuthOptionsPage.by(
          [void Function(VmEmailAuthOptionsPageBuilder) updates]) =
      _$VmEmailAuthOptionsPage;

  static VmEmailAuthOptionsPageBuilder initBuilder() {
    return VmEmailAuthOptionsPageBuilder()
      ..mode = EmailAuthMode.signIn
      ..step = AuthStep.waitingForInput
      ..showPassword = false
      ..email = ''
      ..password = ''
      ..repeatPassword = ''
      ..autovalidate = AutoValidate.disabled;
  }

  Object toJson() =>
      serializers.serializeWith(VmEmailAuthOptionsPage.serializer, this);

  static VmEmailAuthOptionsPage fromJson(String jsonString) =>
      serializers.deserializeWith(
          VmEmailAuthOptionsPage.serializer, json.decode(jsonString));

  static Serializer<VmEmailAuthOptionsPage> get serializer =>
      _$vmEmailAuthOptionsPageSerializer;
}
