library store_conversation_summaries;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';
import 'package:crowdleague/models/conversations/conversation_summary.dart';

part 'store_conversation_summaries.g.dart';

abstract class StoreConversationSummaries extends Object
    with ReduxAction
    implements
        Built<StoreConversationSummaries, StoreConversationSummariesBuilder> {
  BuiltList<ConversationSummary> get summaries;

  StoreConversationSummaries._();

  factory StoreConversationSummaries(
          [void Function(StoreConversationSummariesBuilder) updates]) =
      _$StoreConversationSummaries;

  Object toJson() =>
      serializers.serializeWith(StoreConversationSummaries.serializer, this);

  static StoreConversationSummaries fromJson(String jsonString) =>
      serializers.deserializeWith(
          StoreConversationSummaries.serializer, json.decode(jsonString));

  static Serializer<StoreConversationSummaries> get serializer =>
      _$storeConversationSummariesSerializer;

  @override
  String toString() => 'STORE_CONVERSATION_SUMMARIES';
}
