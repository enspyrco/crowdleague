library save_message_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'save_message_problem.g.dart';

abstract class SaveMessageProblem
    implements
        ProblemBase,
        Built<SaveMessageProblem, SaveMessageProblemBuilder> {
  SaveMessageProblem._();

  factory SaveMessageProblem(
      {String message,
      String trace,
      BuiltMap<String, Object> info}) = _$SaveMessageProblem._;

  factory SaveMessageProblem.by(
          [void Function(SaveMessageProblemBuilder) updates]) =
      _$SaveMessageProblem;

  Object toJson() =>
      serializers.serializeWith(SaveMessageProblem.serializer, this);

  static SaveMessageProblem fromJson(String jsonString) => serializers
      .deserializeWith(SaveMessageProblem.serializer, json.decode(jsonString));

  static Serializer<SaveMessageProblem> get serializer =>
      _$saveMessageProblemSerializer;
}
