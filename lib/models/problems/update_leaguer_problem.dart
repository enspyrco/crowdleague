library update_leaguer_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:built_value/serializer.dart';

part 'update_leaguer_problem.g.dart';

abstract class UpdateLeaguerProblem implements ProblemBase, Built<UpdateLeaguerProblem, UpdateLeaguerProblemBuilder> {

  UpdateLeaguerProblem._();

  factory UpdateLeaguerProblem.by([void Function(UpdateLeaguerProblemBuilder) updates]) = _$UpdateLeaguerProblem;

  Object toJson() =>
    serializers.serializeWith(UpdateLeaguerProblem.serializer, this);


  static UpdateLeaguerProblem fromJson(String jsonString) =>
    serializers.deserializeWith(UpdateLeaguerProblem.serializer, json.decode(jsonString));

  static Serializer<UpdateLeaguerProblem> get serializer => _$updateLeaguerProblemSerializer;
}