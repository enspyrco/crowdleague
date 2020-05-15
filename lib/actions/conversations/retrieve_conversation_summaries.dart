library retrieve_conversation_summaries;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'retrieve_conversation_summaries.g.dart';

abstract class RetrieveConversationSummaries extends Object
    with
        ReduxAction
    implements
        Built<RetrieveConversationSummaries,
            RetrieveConversationSummariesBuilder> {
  RetrieveConversationSummaries._();

  factory RetrieveConversationSummaries(
          [void Function(RetrieveConversationSummariesBuilder) updates]) =
      _$RetrieveConversationSummaries;

  Object toJson() =>
      serializers.serializeWith(RetrieveConversationSummaries.serializer, this);

  static RetrieveConversationSummaries fromJson(String jsonString) =>
      serializers.deserializeWith(
          RetrieveConversationSummaries.serializer, json.decode(jsonString));

  static Serializer<RetrieveConversationSummaries> get serializer =>
      _$retrieveConversationSummariesSerializer;

  @override
  String toString() => 'RETRIEVE_CONVERSATION_SUMMARIES';
}
