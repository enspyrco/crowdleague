library google_sign_in_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:built_value/serializer.dart';

part 'google_sign_in_problem.g.dart';

abstract class GoogleSignInProblem implements ProblemBase, Built<GoogleSignInProblem, GoogleSignInProblemBuilder> {

  GoogleSignInProblem._();

  factory GoogleSignInProblem.by([void Function(GoogleSignInProblemBuilder) updates]) = _$GoogleSignInProblem;

  Object toJson() =>
    serializers.serializeWith(GoogleSignInProblem.serializer, this);


  static GoogleSignInProblem fromJson(String jsonString) =>
    serializers.deserializeWith(GoogleSignInProblem.serializer, json.decode(jsonString));

  static Serializer<GoogleSignInProblem> get serializer => _$googleSignInProblemSerializer;
}