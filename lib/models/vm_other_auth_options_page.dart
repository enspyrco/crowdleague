library vm_other_auth_options_page;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/enums/auth_step.dart';
import 'package:crowdleague/models/enums/email_auth_mode.dart';
import 'package:crowdleague/models/serializers.dart';

part 'vm_other_auth_options_page.g.dart';

abstract class VmOtherAuthOptionsPage
    implements Built<VmOtherAuthOptionsPage, VmOtherAuthOptionsPageBuilder> {
  EmailAuthMode get mode;
  AuthStep get step;
  bool get showPassword;
  String get email;
  String get password;
  String get repeatPassword;

  VmOtherAuthOptionsPage._();

  factory VmOtherAuthOptionsPage(
          [void Function(VmOtherAuthOptionsPageBuilder) updates]) =
      _$VmOtherAuthOptionsPage;

  static VmOtherAuthOptionsPageBuilder initBuilder() {
    return VmOtherAuthOptionsPageBuilder()
      ..mode = EmailAuthMode.signIn
      ..step = AuthStep.waitingForInput
      ..showPassword = false
      ..email = ''
      ..password = ''
      ..repeatPassword = '';
  }

  Object toJson() =>
      serializers.serializeWith(VmOtherAuthOptionsPage.serializer, this);

  static VmOtherAuthOptionsPage fromJson(String jsonString) =>
      serializers.deserializeWith(
          VmOtherAuthOptionsPage.serializer, json.decode(jsonString));

  static Serializer<VmOtherAuthOptionsPage> get serializer =>
      _$vmOtherAuthOptionsPageSerializer;
}
