library problem;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'problem.g.dart';

abstract class Problem implements Built<Problem, ProblemBuilder> {
  ProblemType get type;

  String get message;

  @nullable
  String get trace;

  @nullable
  AppState get state;

  Problem._();

  factory Problem([void Function(ProblemBuilder) updates]) = _$Problem;

  Object toJson() => serializers.serializeWith(Problem.serializer, this);

  static Problem fromJson(String jsonString) =>
      serializers.deserializeWith(Problem.serializer, json.decode(jsonString));

  static Serializer<Problem> get serializer => _$problemSerializer;
}
