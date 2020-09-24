library disregard_profile_pics;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'disregard_profile_pics.g.dart';

abstract class DisregardProfilePics extends Object
    with ReduxAction
    implements Built<DisregardProfilePics, DisregardProfilePicsBuilder> {
  DisregardProfilePics._();

  factory DisregardProfilePics(
          [void Function(DisregardProfilePicsBuilder) updates]) =
      _$DisregardProfilePics;

  Object toJson() =>
      serializers.serializeWith(DisregardProfilePics.serializer, this);

  static DisregardProfilePics fromJson(String jsonString) =>
      serializers.deserializeWith(
          DisregardProfilePics.serializer, json.decode(jsonString));

  static Serializer<DisregardProfilePics> get serializer =>
      _$disregardProfilePicsSerializer;

  @override
  String toString() => 'DISREGARD_PROFILE_PICS';
}
