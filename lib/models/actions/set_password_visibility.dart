library set_password_visibility;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import './redux_action.dart';
import '../serializers.dart';

part 'set_password_visibility.g.dart';

abstract class SetPasswordVisibility extends Object
    with ReduxAction
    implements Built<SetPasswordVisibility, SetPasswordVisibilityBuilder> {
  bool get visible;

  SetPasswordVisibility._();

  factory SetPasswordVisibility(
          [void Function(SetPasswordVisibilityBuilder) updates]) =
      _$SetPasswordVisibility;

  Object toJson() =>
      serializers.serializeWith(SetPasswordVisibility.serializer, this);

  static SetPasswordVisibility fromJson(String jsonString) =>
      serializers.deserializeWith(
          SetPasswordVisibility.serializer, json.decode(jsonString));

  static Serializer<SetPasswordVisibility> get serializer =>
      _$setPasswordVisibilitySerializer;
}
