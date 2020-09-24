library select_profile_pic;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'select_profile_pic.g.dart';

abstract class SelectProfilePic extends Object
    with ReduxAction
    implements Built<SelectProfilePic, SelectProfilePicBuilder> {
  String get picId;

  SelectProfilePic._();

  factory SelectProfilePic([void Function(SelectProfilePicBuilder) updates]) =
      _$SelectProfilePic;

  Object toJson() =>
      serializers.serializeWith(SelectProfilePic.serializer, this);

  static SelectProfilePic fromJson(String jsonString) => serializers
      .deserializeWith(SelectProfilePic.serializer, json.decode(jsonString));

  static Serializer<SelectProfilePic> get serializer =>
      _$selectProfilePicSerializer;

  @override
  String toString() => 'SELECT_PROFILE_PIC';
}
