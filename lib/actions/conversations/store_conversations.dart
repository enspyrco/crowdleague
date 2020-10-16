library store_conversations;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/conversations/conversation_summary.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'store_conversations.g.dart';

abstract class StoreConversations extends Object
    with ReduxAction
    implements Built<StoreConversations, StoreConversationsBuilder> {
  BuiltList<ConversationSummary> get summaries;

  StoreConversations._();

  factory StoreConversations(
          {@required BuiltList<ConversationSummary> summaries}) =
      _$StoreConversations._;

  factory StoreConversations.by(
          [void Function(StoreConversationsBuilder) updates]) =
      _$StoreConversations;

  Object toJson() =>
      serializers.serializeWith(StoreConversations.serializer, this);

  static StoreConversations fromJson(String jsonString) => serializers
      .deserializeWith(StoreConversations.serializer, json.decode(jsonString));

  static Serializer<StoreConversations> get serializer =>
      _$storeConversationsSerializer;

  @override
  String toString() => 'STORE_CONVERSATIONS';
}
