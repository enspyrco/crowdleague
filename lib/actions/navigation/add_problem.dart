library add_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/app/problem.dart';
import 'package:crowdleague/models/app/serializers.dart';
import 'package:meta/meta.dart';

part 'add_problem.g.dart';

abstract class AddProblem extends Object
    with ReduxAction
    implements Built<AddProblem, AddProblemBuilder> {
  Problem get problem;

  AddProblem._();

  factory AddProblem([void Function(AddProblemBuilder) updates]) = _$AddProblem;

  factory AddProblem.from({
    @required String message,
    @required ProblemType type,
    String traceString,
    BuiltMap<String, Object> info,
    AppState state,
  }) {
    return AddProblem((b) => b
      ..problem.message = message
      ..problem.type = type
      ..problem.trace = traceString
      ..problem.info = info?.toBuilder()
      ..problem.state = state?.toBuilder());
  }

  Object toJson() => serializers.serializeWith(AddProblem.serializer, this);

  static AddProblem fromJson(String jsonString) => serializers.deserializeWith(
      AddProblem.serializer, json.decode(jsonString));

  static Serializer<AddProblem> get serializer => _$addProblemSerializer;

  @override
  String toString() => 'ADD_PROBLEM';
}
