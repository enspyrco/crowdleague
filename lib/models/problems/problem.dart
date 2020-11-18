library problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:built_value/serializer.dart';

part 'problem.g.dart';

abstract class Problem implements ProblemBase, Built<Problem, ProblemBuilder> {

  Problem._();

  factory Problem.by([void Function(ProblemBuilder) updates]) = _$Problem;

  Object toJson() =>
    serializers.serializeWith(Problem.serializer, this);


  static Problem fromJson(String jsonString) =>
    serializers.deserializeWith(Problem.serializer, json.decode(jsonString));

  static Serializer<Problem> get serializer => _$problemSerializer;
}