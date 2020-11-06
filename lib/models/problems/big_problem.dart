library big_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/problems/problem.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'big_problem.g.dart';

abstract class BigProblem
    implements Problem, Built<BigProblem, BigProblemBuilder> {
  BigProblem._();

  factory BigProblem.by([void Function(BigProblemBuilder) updates]) =
      _$BigProblem;

  factory BigProblem() = _$BigProblem._;

  Object toJson() => serializers.serializeWith(BigProblem.serializer, this);

  static BigProblem fromJson(String jsonString) => serializers.deserializeWith(
      BigProblem.serializer, json.decode(jsonString));

  static Serializer<BigProblem> get serializer => _$bigProblemSerializer;
}
