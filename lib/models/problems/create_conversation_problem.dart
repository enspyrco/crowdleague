library create_conversation_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'create_conversation_problem.g.dart';

abstract class CreateConversationProblem
    implements
        ProblemBase,
        Built<CreateConversationProblem, CreateConversationProblemBuilder> {
  CreateConversationProblem._();

  factory CreateConversationProblem(
      {String message,
      String trace,
      BuiltMap<String, Object> info}) = _$CreateConversationProblem._;

  factory CreateConversationProblem.by(
          [void Function(CreateConversationProblemBuilder) updates]) =
      _$CreateConversationProblem;

  Object toJson() =>
      serializers.serializeWith(CreateConversationProblem.serializer, this);

  static CreateConversationProblem fromJson(String jsonString) =>
      serializers.deserializeWith(
          CreateConversationProblem.serializer, json.decode(jsonString));

  static Serializer<CreateConversationProblem> get serializer =>
      _$createConversationProblemSerializer;
}
