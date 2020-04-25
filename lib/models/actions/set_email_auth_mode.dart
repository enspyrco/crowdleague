library set_email_auth_mode;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/enums/email_auth_mode.dart';

import './redux_action.dart';
import '../serializers.dart';

part 'set_email_auth_mode.g.dart';

abstract class SetEmailAuthMode extends Object
    with ReduxAction
    implements Built<SetEmailAuthMode, SetEmailAuthModeBuilder> {
  EmailAuthMode get mode;

  SetEmailAuthMode._();

  factory SetEmailAuthMode([void Function(SetEmailAuthModeBuilder) updates]) =
      _$SetEmailAuthMode;

  Object toJson() =>
      serializers.serializeWith(SetEmailAuthMode.serializer, this);

  static SetEmailAuthMode fromJson(String jsonString) => serializers
      .deserializeWith(SetEmailAuthMode.serializer, json.decode(jsonString));

  static Serializer<SetEmailAuthMode> get serializer =>
      _$setEmailAuthModeSerializer;
}
