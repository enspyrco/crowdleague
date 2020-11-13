library database_store_controller_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:built_value/serializer.dart';

part 'database_store_controller_problem.g.dart';

abstract class DatabaseStoreControllerProblem implements ProblemBase, Built<DatabaseStoreControllerProblem, DatabaseStoreControllerProblemBuilder> {

  DatabaseStoreControllerProblem._();

  factory DatabaseStoreControllerProblem.by([void Function(DatabaseStoreControllerProblemBuilder) updates]) = _$DatabaseStoreControllerProblem;

  Object toJson() =>
    serializers.serializeWith(DatabaseStoreControllerProblem.serializer, this);


  static DatabaseStoreControllerProblem fromJson(String jsonString) =>
    serializers.deserializeWith(DatabaseStoreControllerProblem.serializer, json.decode(jsonString));

  static Serializer<DatabaseStoreControllerProblem> get serializer => _$databaseStoreControllerProblemSerializer;
}