library disregard_profile_pics_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'disregard_profile_pics_problem.g.dart';

abstract class DisregardProfilePicsProblem
    implements
        ProblemBase,
        Built<DisregardProfilePicsProblem, DisregardProfilePicsProblemBuilder> {
  DisregardProfilePicsProblem._();

  factory DisregardProfilePicsProblem(
      {String message,
      String trace,
      BuiltMap<String, Object> info}) = _$DisregardProfilePicsProblem._;

  factory DisregardProfilePicsProblem.by(
          [void Function(DisregardProfilePicsProblemBuilder) updates]) =
      _$DisregardProfilePicsProblem;

  Object toJson() =>
      serializers.serializeWith(DisregardProfilePicsProblem.serializer, this);

  static DisregardProfilePicsProblem fromJson(String jsonString) =>
      serializers.deserializeWith(
          DisregardProfilePicsProblem.serializer, json.decode(jsonString));

  static Serializer<DisregardProfilePicsProblem> get serializer =>
      _$disregardProfilePicsProblemSerializer;
}
