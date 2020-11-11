library apple_sign_in_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:crowdleague/models/problems/problem.dart';
import 'package:built_value/serializer.dart';

part 'apple_sign_in_problem.g.dart';

abstract class AppleSignInProblem implements Problem, Built<AppleSignInProblem, AppleSignInProblemBuilder> {

  AppleSignInProblem._();

  factory AppleSignInProblem.by([void Function(AppleSignInProblemBuilder) updates]) = _$AppleSignInProblem;

  Object toJson() =>
    serializers.serializeWith(AppleSignInProblem.serializer, this);


  static AppleSignInProblem fromJson(String jsonString) =>
    serializers.deserializeWith(AppleSignInProblem.serializer, json.decode(jsonString));

  static Serializer<AppleSignInProblem> get serializer => _$appleSignInProblemSerializer;
}