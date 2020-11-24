library update_new_conversation_page_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:built_value/serializer.dart';

part 'update_new_conversation_page_problem.g.dart';

abstract class UpdateNewConversationPageProblem implements ProblemBase, Built<UpdateNewConversationPageProblem, UpdateNewConversationPageProblemBuilder> {

  UpdateNewConversationPageProblem._();

  factory UpdateNewConversationPageProblem.by([void Function(UpdateNewConversationPageProblemBuilder) updates]) = _$UpdateNewConversationPageProblem;

  Object toJson() =>
    serializers.serializeWith(UpdateNewConversationPageProblem.serializer, this);


  static UpdateNewConversationPageProblem fromJson(String jsonString) =>
    serializers.deserializeWith(UpdateNewConversationPageProblem.serializer, json.decode(jsonString));

  static Serializer<UpdateNewConversationPageProblem> get serializer => _$updateNewConversationPageProblemSerializer;
}