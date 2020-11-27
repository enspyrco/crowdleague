library sign_out_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'sign_out_problem.g.dart';

abstract class SignOutProblem
    implements ProblemBase, Built<SignOutProblem, SignOutProblemBuilder> {
  SignOutProblem._();

  factory SignOutProblem(
      {String message,
      String trace,
      BuiltMap<String, Object> info}) = _$SignOutProblem._;

  factory SignOutProblem.by([void Function(SignOutProblemBuilder) updates]) =
      _$SignOutProblem;

  Object toJson() => serializers.serializeWith(SignOutProblem.serializer, this);

  static SignOutProblem fromJson(String jsonString) => serializers
      .deserializeWith(SignOutProblem.serializer, json.decode(jsonString));

  static Serializer<SignOutProblem> get serializer =>
      _$signOutProblemSerializer;
}
