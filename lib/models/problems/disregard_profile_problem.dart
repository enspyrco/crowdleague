library disregard_profile_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'disregard_profile_problem.g.dart';

abstract class DisregardProfileProblem
    implements
        ProblemBase,
        Built<DisregardProfileProblem, DisregardProfileProblemBuilder> {
  DisregardProfileProblem._();

  factory DisregardProfileProblem(
      {String message,
      String trace,
      BuiltMap<String, Object> info}) = _$DisregardProfileProblem._;

  factory DisregardProfileProblem.by(
          [void Function(DisregardProfileProblemBuilder) updates]) =
      _$DisregardProfileProblem;

  Object toJson() =>
      serializers.serializeWith(DisregardProfileProblem.serializer, this);

  static DisregardProfileProblem fromJson(String jsonString) =>
      serializers.deserializeWith(
          DisregardProfileProblem.serializer, json.decode(jsonString));

  static Serializer<DisregardProfileProblem> get serializer =>
      _$disregardProfileProblemSerializer;
}
