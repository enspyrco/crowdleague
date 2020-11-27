library disregard_messages_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'disregard_messages_problem.g.dart';

abstract class DisregardMessagesProblem
    implements
        ProblemBase,
        Built<DisregardMessagesProblem, DisregardMessagesProblemBuilder> {
  DisregardMessagesProblem._();

  factory DisregardMessagesProblem(
      {String message,
      String trace,
      BuiltMap<String, Object> info}) = _$DisregardMessagesProblem._;

  factory DisregardMessagesProblem.by(
          [void Function(DisregardMessagesProblemBuilder) updates]) =
      _$DisregardMessagesProblem;

  Object toJson() =>
      serializers.serializeWith(DisregardMessagesProblem.serializer, this);

  static DisregardMessagesProblem fromJson(String jsonString) =>
      serializers.deserializeWith(
          DisregardMessagesProblem.serializer, json.decode(jsonString));

  static Serializer<DisregardMessagesProblem> get serializer =>
      _$disregardMessagesProblemSerializer;
}
