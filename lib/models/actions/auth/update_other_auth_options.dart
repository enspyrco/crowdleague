library update_other_auth_options;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/enums/email_auth_mode.dart';
import 'package:crowdleague/models/enums/email_auth_step.dart';

import 'package:crowdleague/models/actions/redux_action.dart';
import 'package:crowdleague/models/serializers.dart';

part 'update_other_auth_options.g.dart';

abstract class UpdateOtherAuthOptions extends Object
    with ReduxAction
    implements Built<UpdateOtherAuthOptions, UpdateOtherAuthOptionsBuilder> {
  @nullable
  EmailAuthMode get mode;
  @nullable
  EmailAuthStep get step;
  @nullable
  bool get showPassword;
  @nullable
  String get email;
  @nullable
  String get password;
  @nullable
  String get repeatPassword;

  UpdateOtherAuthOptions._();

  factory UpdateOtherAuthOptions(
          [void Function(UpdateOtherAuthOptionsBuilder) updates]) =
      _$UpdateOtherAuthOptions;

  Object toJson() =>
      serializers.serializeWith(UpdateOtherAuthOptions.serializer, this);

  static UpdateOtherAuthOptions fromJson(String jsonString) =>
      serializers.deserializeWith(
          UpdateOtherAuthOptions.serializer, json.decode(jsonString));

  static Serializer<UpdateOtherAuthOptions> get serializer =>
      _$updateOtherAuthOptionsSerializer;
}
