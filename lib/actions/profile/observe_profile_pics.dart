library observe_profile_pics;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'observe_profile_pics.g.dart';

abstract class ObserveProfilePics extends Object
    with ReduxAction
    implements Built<ObserveProfilePics, ObserveProfilePicsBuilder> {
  ObserveProfilePics._();

  factory ObserveProfilePics(
          [void Function(ObserveProfilePicsBuilder) updates]) =
      _$ObserveProfilePics;

  Object toJson() =>
      serializers.serializeWith(ObserveProfilePics.serializer, this);

  static ObserveProfilePics fromJson(String jsonString) => serializers
      .deserializeWith(ObserveProfilePics.serializer, json.decode(jsonString));

  static Serializer<ObserveProfilePics> get serializer =>
      _$observeProfilePicsSerializer;

  @override
  String toString() => 'OBSERVE_PROFILE_PICS';
}
