library plum_database_stream_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'plum_database_stream_problem.g.dart';

abstract class PlumDatabaseStreamProblem
    implements
        ProblemBase,
        Built<PlumDatabaseStreamProblem, PlumDatabaseStreamProblemBuilder> {
  PlumDatabaseStreamProblem._();

  factory PlumDatabaseStreamProblem(
      {String message,
      String trace,
      BuiltMap<String, Object> info}) = _$PlumDatabaseStreamProblem._;

  factory PlumDatabaseStreamProblem.by(
          [void Function(PlumDatabaseStreamProblemBuilder) updates]) =
      _$PlumDatabaseStreamProblem;

  Object toJson() =>
      serializers.serializeWith(PlumDatabaseStreamProblem.serializer, this);

  static PlumDatabaseStreamProblem fromJson(String jsonString) =>
      serializers.deserializeWith(
          PlumDatabaseStreamProblem.serializer, json.decode(jsonString));

  static Serializer<PlumDatabaseStreamProblem> get serializer =>
      _$plumDatabaseStreamProblemSerializer;
}
