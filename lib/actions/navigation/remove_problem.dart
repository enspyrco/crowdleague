import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'remove_problem.g.dart';

abstract class RemoveProblem extends Object
    with ReduxAction
    implements Built<RemoveProblem, RemoveProblemBuilder> {
  ProblemBase get problem;

  RemoveProblem._();

  factory RemoveProblem({@required ProblemBase problem}) = _$RemoveProblem._;

  factory RemoveProblem.by([void Function(RemoveProblemBuilder) updates]) =
      _$RemoveProblem;

  Object toJson() => serializers.serializeWith(RemoveProblem.serializer, this);

  static RemoveProblem fromJson(String jsonString) => serializers
      .deserializeWith(RemoveProblem.serializer, json.decode(jsonString));

  static Serializer<RemoveProblem> get serializer => _$removeProblemSerializer;

  @override
  String toString() => 'REMOVE_PROBLEM';
}
