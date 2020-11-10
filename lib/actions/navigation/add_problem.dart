library add_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/problems/problem.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'add_problem.g.dart';

abstract class AddProblem extends Object
    with ReduxAction
    implements Built<AddProblem, AddProblemBuilder> {
  Problem get problem;

  AddProblem._();

  factory AddProblem({@required Problem problem}) = _$AddProblem._;

  factory AddProblem.by([void Function(AddProblemBuilder) updates]) =
      _$AddProblem;

  factory AddProblem.from({
    @required String message,
    String trace,
    BuiltMap<String, Object> info,
  }) =>
      AddProblem.by((b) => b
        ..problem.message = message
        ..problem.trace = trace
        ..problem.info = info?.toBuilder());

  Object toJson() => serializers.serializeWith(AddProblem.serializer, this);

  static AddProblem fromJson(String jsonString) => serializers.deserializeWith(
      AddProblem.serializer, json.decode(jsonString));

  static Serializer<AddProblem> get serializer => _$addProblemSerializer;

  @override
  String toString() => 'ADD_PROBLEM';
}
