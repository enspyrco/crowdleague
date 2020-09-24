library clear_user_data;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'clear_user_data.g.dart';

abstract class ClearUserData extends Object
    with ReduxAction
    implements Built<ClearUserData, ClearUserDataBuilder> {
  ClearUserData._();

  factory ClearUserData([void Function(ClearUserDataBuilder) updates]) =
      _$ClearUserData;

  Object toJson() => serializers.serializeWith(ClearUserData.serializer, this);

  static ClearUserData fromJson(String jsonString) => serializers
      .deserializeWith(ClearUserData.serializer, json.decode(jsonString));

  static Serializer<ClearUserData> get serializer => _$clearUserDataSerializer;

  @override
  String toString() => 'CLEAR_USER_DATA';
}
