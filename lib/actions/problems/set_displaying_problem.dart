library set_displaying_problem;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'set_displaying_problem.g.dart';

abstract class SetDisplayingProblem extends Object
    with ReduxAction
    implements Built<SetDisplayingProblem, SetDisplayingProblemBuilder> {
  bool get displaying;

  SetDisplayingProblem._();

  factory SetDisplayingProblem(
          [void Function(SetDisplayingProblemBuilder) updates]) =
      _$SetDisplayingProblem;

  Object toJson() =>
      serializers.serializeWith(SetDisplayingProblem.serializer, this);

  static SetDisplayingProblem fromJson(String jsonString) =>
      serializers.deserializeWith(
          SetDisplayingProblem.serializer, json.decode(jsonString));

  static Serializer<SetDisplayingProblem> get serializer =>
      _$setDisplayingProblemSerializer;

  @override
  String toString() => 'SET_DISPLAYING_PROBLEM';
}
