library email_sign_up_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:crowdleague/models/problems/problem.dart';
import 'package:built_value/serializer.dart';

part 'email_sign_up_problem.g.dart';

abstract class EmailSignUpProblem implements Problem, Built<EmailSignUpProblem, EmailSignUpProblemBuilder> {

  EmailSignUpProblem._();

  factory EmailSignUpProblem.by([void Function(EmailSignUpProblemBuilder) updates]) = _$EmailSignUpProblem;

  Object toJson() =>
    serializers.serializeWith(EmailSignUpProblem.serializer, this);


  static EmailSignUpProblem fromJson(String jsonString) =>
    serializers.deserializeWith(EmailSignUpProblem.serializer, json.decode(jsonString));

  static Serializer<EmailSignUpProblem> get serializer => _$emailSignUpProblemSerializer;
}