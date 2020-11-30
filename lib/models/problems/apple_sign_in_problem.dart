library apple_sign_in_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'apple_sign_in_problem.g.dart';

abstract class AppleSignInProblem
    implements
        ProblemBase,
        Built<AppleSignInProblem, AppleSignInProblemBuilder> {
  AppleSignInProblem._();

  factory AppleSignInProblem(
      {String message,
      String trace,
      BuiltMap<String, Object> info}) = _$AppleSignInProblem._;

  factory AppleSignInProblem.by(
          [void Function(AppleSignInProblemBuilder) updates]) =
      _$AppleSignInProblem;

  Object toJson() =>
      serializers.serializeWith(AppleSignInProblem.serializer, this);

  static AppleSignInProblem fromJson(String jsonString) => serializers
      .deserializeWith(AppleSignInProblem.serializer, json.decode(jsonString));

  static Serializer<AppleSignInProblem> get serializer =>
      _$appleSignInProblemSerializer;
}
