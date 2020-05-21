library pick_profile_pic;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'pick_profile_pic.g.dart';

abstract class PickProfilePic extends Object
    with ReduxAction
    implements Built<PickProfilePic, PickProfilePicBuilder> {
  PickProfilePic._();

  factory PickProfilePic([void Function(PickProfilePicBuilder) updates]) =
      _$PickProfilePic;

  Object toJson() => serializers.serializeWith(PickProfilePic.serializer, this);

  static PickProfilePic fromJson(String jsonString) => serializers
      .deserializeWith(PickProfilePic.serializer, json.decode(jsonString));

  static Serializer<PickProfilePic> get serializer =>
      _$pickProfilePicSerializer;

  @override
  String toString() => 'PICK_PROFILE_PIC';
}
