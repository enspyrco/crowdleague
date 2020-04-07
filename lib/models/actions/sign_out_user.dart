library sign_out_user;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import './redux_action.dart';
import '../serializers.dart';

part 'sign_out_user.g.dart';

abstract class SignOutUser extends Object
    with ReduxAction
    implements Built<SignOutUser, SignOutUserBuilder> {
  SignOutUser._();

  factory SignOutUser([void Function(SignOutUserBuilder) updates]) =
      _$SignOutUser;

  Object toJson() => serializers.serializeWith(SignOutUser.serializer, this);

  static SignOutUser fromJson(String jsonString) => serializers.deserializeWith(
      SignOutUser.serializer, json.decode(jsonString));

  static Serializer<SignOutUser> get serializer => _$signOutUserSerializer;
}
