library observe_profile_pics_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/problems/problem.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'observe_profile_pics_problem.g.dart';

abstract class ObserveProfilePicsProblem
    implements
        Problem,
        Built<ObserveProfilePicsProblem, ObserveProfilePicsProblemBuilder> {
  ObserveProfilePicsProblem._();

  factory ObserveProfilePicsProblem() = _$ObserveProfilePicsProblem._;

  factory ObserveProfilePicsProblem.by(
          [void Function(ObserveProfilePicsProblemBuilder) updates]) =
      _$ObserveProfilePicsProblem;

  Object toJson() =>
      serializers.serializeWith(ObserveProfilePicsProblem.serializer, this);

  static ObserveProfilePicsProblem fromJson(String jsonString) =>
      serializers.deserializeWith(
          ObserveProfilePicsProblem.serializer, json.decode(jsonString));

  static Serializer<ObserveProfilePicsProblem> get serializer =>
      _$observeProfilePicsProblemSerializer;
}
