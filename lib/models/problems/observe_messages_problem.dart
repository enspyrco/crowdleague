library observe_messages_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'observe_messages_problem.g.dart';

abstract class ObserveMessagesProblem
    implements
        ProblemBase,
        Built<ObserveMessagesProblem, ObserveMessagesProblemBuilder> {
  ObserveMessagesProblem._();

  factory ObserveMessagesProblem(
      {String message,
      String trace,
      BuiltMap<String, Object> info}) = _$ObserveMessagesProblem._;

  factory ObserveMessagesProblem.by(
          [void Function(ObserveMessagesProblemBuilder) updates]) =
      _$ObserveMessagesProblem;

  Object toJson() =>
      serializers.serializeWith(ObserveMessagesProblem.serializer, this);

  static ObserveMessagesProblem fromJson(String jsonString) =>
      serializers.deserializeWith(
          ObserveMessagesProblem.serializer, json.decode(jsonString));

  static Serializer<ObserveMessagesProblem> get serializer =>
      _$observeMessagesProblemSerializer;
}
