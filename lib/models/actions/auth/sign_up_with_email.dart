library sign_up_with_email;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/models/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'sign_up_with_email.g.dart';

abstract class SignUpWithEmail extends Object
    with ReduxAction
    implements Built<SignUpWithEmail, SignUpWithEmailBuilder> {
  SignUpWithEmail._();

  factory SignUpWithEmail([void Function(SignUpWithEmailBuilder) updates]) =
      _$SignUpWithEmail;

  Object toJson() =>
      serializers.serializeWith(SignUpWithEmail.serializer, this);

  static SignUpWithEmail fromJson(String jsonString) => serializers
      .deserializeWith(SignUpWithEmail.serializer, json.decode(jsonString));

  static Serializer<SignUpWithEmail> get serializer =>
      _$signUpWithEmailSerializer;

  @override
  String toString() => 'SIGN_UP_WITH_EMAIL';
}
