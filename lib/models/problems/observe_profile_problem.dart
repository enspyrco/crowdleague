library observe_profile_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'observe_profile_problem.g.dart';

abstract class ObserveProfileProblem
    implements
        ProblemBase,
        Built<ObserveProfileProblem, ObserveProfileProblemBuilder> {
  ObserveProfileProblem._();

  factory ObserveProfileProblem(
      {String message,
      String trace,
      BuiltMap<String, Object> info}) = _$ObserveProfileProblem._;

  factory ObserveProfileProblem.by(
          [void Function(ObserveProfileProblemBuilder) updates]) =
      _$ObserveProfileProblem;

  Object toJson() =>
      serializers.serializeWith(ObserveProfileProblem.serializer, this);

  static ObserveProfileProblem fromJson(String jsonString) =>
      serializers.deserializeWith(
          ObserveProfileProblem.serializer, json.decode(jsonString));

  static Serializer<ObserveProfileProblem> get serializer =>
      _$observeProfileProblemSerializer;
}
