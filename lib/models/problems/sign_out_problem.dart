library sign_out_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:crowdleague/models/problems/problem.dart';
import 'package:built_value/serializer.dart';

part 'sign_out_problem.g.dart';

abstract class SignOutProblem implements Problem, Built<SignOutProblem, SignOutProblemBuilder> {

  SignOutProblem._();

  factory SignOutProblem.by([void Function(SignOutProblemBuilder) updates]) = _$SignOutProblem;

  Object toJson() =>
    serializers.serializeWith(SignOutProblem.serializer, this);


  static SignOutProblem fromJson(String jsonString) =>
    serializers.deserializeWith(SignOutProblem.serializer, json.decode(jsonString));

  static Serializer<SignOutProblem> get serializer => _$signOutProblemSerializer;
}