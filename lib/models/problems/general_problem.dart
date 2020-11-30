library general_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'general_problem.g.dart';

/// This is an unspecific Problem subclass for times when adding a Problem to
/// the redux [Store] doesn't warrant creating a specific subclass or using one
/// that's already available.
abstract class GeneralProblem
    implements ProblemBase, Built<GeneralProblem, GeneralProblemBuilder> {
  GeneralProblem._();

  factory GeneralProblem(
      {String message,
      String trace,
      BuiltMap<String, Object> info}) = _$GeneralProblem._;

  factory GeneralProblem.by([void Function(GeneralProblemBuilder) updates]) =
      _$GeneralProblem;

  Object toJson() => serializers.serializeWith(GeneralProblem.serializer, this);

  static GeneralProblem fromJson(String jsonString) => serializers
      .deserializeWith(GeneralProblem.serializer, json.decode(jsonString));

  static Serializer<GeneralProblem> get serializer =>
      _$generalProblemSerializer;
}
