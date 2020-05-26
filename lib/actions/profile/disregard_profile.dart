library disregard_profile;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'disregard_profile.g.dart';

abstract class DisregardProfile extends Object
    with ReduxAction
    implements Built<DisregardProfile, DisregardProfileBuilder> {
  DisregardProfile._();

  factory DisregardProfile([void Function(DisregardProfileBuilder) updates]) =
      _$DisregardProfile;

  Object toJson() =>
      serializers.serializeWith(DisregardProfile.serializer, this);

  static DisregardProfile fromJson(String jsonString) => serializers
      .deserializeWith(DisregardProfile.serializer, json.decode(jsonString));

  static Serializer<DisregardProfile> get serializer =>
      _$disregardProfileSerializer;

  @override
  String toString() => 'DISREGARD_PROFILE';
}
