library display_problem;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/problems/problem.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'display_problem.g.dart';

abstract class DisplayProblem extends Object
    with ReduxAction
    implements Built<DisplayProblem, DisplayProblemBuilder> {
  Problem get problem;

  DisplayProblem._();

  factory DisplayProblem({@required Problem problem}) = _$DisplayProblem._;

  factory DisplayProblem.by([void Function(DisplayProblemBuilder) updates]) =
      _$DisplayProblem;

  Object toJson() => serializers.serializeWith(DisplayProblem.serializer, this);

  static DisplayProblem fromJson(String jsonString) => serializers
      .deserializeWith(DisplayProblem.serializer, json.decode(jsonString));

  static Serializer<DisplayProblem> get serializer =>
      _$displayProblemSerializer;

  @override
  String toString() => 'DISPLAY_PROBLEM';
}
