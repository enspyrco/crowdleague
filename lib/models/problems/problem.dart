library problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'problem.g.dart';

abstract class Problem implements Built<Problem, ProblemBuilder> {
  String get errorMessage;
  String get stackTrace;
  BuiltMap<String, Object> get info;

  Problem._();

  factory Problem(
      {@required String errorMessage,
      @required String stackTrace,
      BuiltMap<String, Object> info}) = _$Problem._;

  factory Problem.by([void Function(ProblemBuilder) updates]) = _$Problem;

  Object toJson() => serializers.serializeWith(Problem.serializer, this);

  static Problem fromJson(String jsonString) =>
      serializers.deserializeWith(Problem.serializer, json.decode(jsonString));

  static Serializer<Problem> get serializer => _$problemSerializer;
}
