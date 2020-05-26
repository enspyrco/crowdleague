library observe_profile;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'observe_profile.g.dart';

abstract class ObserveProfile extends Object
    with ReduxAction
    implements Built<ObserveProfile, ObserveProfileBuilder> {
  ObserveProfile._();

  factory ObserveProfile([void Function(ObserveProfileBuilder) updates]) =
      _$ObserveProfile;

  Object toJson() => serializers.serializeWith(ObserveProfile.serializer, this);

  static ObserveProfile fromJson(String jsonString) => serializers
      .deserializeWith(ObserveProfile.serializer, json.decode(jsonString));

  static Serializer<ObserveProfile> get serializer =>
      _$observeProfileSerializer;

  @override
  String toString() => 'OBSERVE_PROFILE';
}
