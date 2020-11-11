library disregard_conversations_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:crowdleague/models/problems/problem.dart';
import 'package:built_value/serializer.dart';

part 'disregard_conversations_problem.g.dart';

abstract class DisregardConversationsProblem implements Problem, Built<DisregardConversationsProblem, DisregardConversationsProblemBuilder> {

  DisregardConversationsProblem._();

  factory DisregardConversationsProblem.by([void Function(DisregardConversationsProblemBuilder) updates]) = _$DisregardConversationsProblem;

  Object toJson() =>
    serializers.serializeWith(DisregardConversationsProblem.serializer, this);


  static DisregardConversationsProblem fromJson(String jsonString) =>
    serializers.deserializeWith(DisregardConversationsProblem.serializer, json.decode(jsonString));

  static Serializer<DisregardConversationsProblem> get serializer => _$disregardConversationsProblemSerializer;
}