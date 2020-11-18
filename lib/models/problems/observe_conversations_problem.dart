library observe_conversations_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:built_value/serializer.dart';

part 'observe_conversations_problem.g.dart';

abstract class ObserveConversationsProblem implements ProblemBase, Built<ObserveConversationsProblem, ObserveConversationsProblemBuilder> {

  ObserveConversationsProblem._();

  factory ObserveConversationsProblem.by([void Function(ObserveConversationsProblemBuilder) updates]) = _$ObserveConversationsProblem;

  Object toJson() =>
    serializers.serializeWith(ObserveConversationsProblem.serializer, this);


  static ObserveConversationsProblem fromJson(String jsonString) =>
    serializers.deserializeWith(ObserveConversationsProblem.serializer, json.decode(jsonString));

  static Serializer<ObserveConversationsProblem> get serializer => _$observeConversationsProblemSerializer;
}