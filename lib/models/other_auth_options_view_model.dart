library other_auth_options_view_model;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/enums/email_auth_mode.dart';
import 'package:crowdleague/models/enums/email_auth_step.dart';
import 'package:crowdleague/models/serializers.dart';

part 'other_auth_options_view_model.g.dart';

abstract class OtherAuthOptionsViewModel
    implements
        Built<OtherAuthOptionsViewModel, OtherAuthOptionsViewModelBuilder> {
  EmailAuthMode get mode;
  EmailAuthStep get step;
  bool get showPassword;
  String get email;
  String get password;
  String get repeatPassword;

  OtherAuthOptionsViewModel._();

  factory OtherAuthOptionsViewModel(
          [void Function(OtherAuthOptionsViewModelBuilder) updates]) =
      _$OtherAuthOptionsViewModel;

  static OtherAuthOptionsViewModelBuilder initBuilder() {
    return OtherAuthOptionsViewModelBuilder()
      ..mode = EmailAuthMode.signIn
      ..step = EmailAuthStep.waitingForUser
      ..showPassword = false
      ..email = ''
      ..password = ''
      ..repeatPassword = '';
  }

  Object toJson() =>
      serializers.serializeWith(OtherAuthOptionsViewModel.serializer, this);

  static OtherAuthOptionsViewModel fromJson(String jsonString) =>
      serializers.deserializeWith(
          OtherAuthOptionsViewModel.serializer, json.decode(jsonString));

  static Serializer<OtherAuthOptionsViewModel> get serializer =>
      _$otherAuthOptionsViewModelSerializer;
}
