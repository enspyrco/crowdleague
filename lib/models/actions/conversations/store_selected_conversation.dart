library store_selected_conversation;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/models/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';
import 'package:crowdleague/models/conversations/conversation_item.dart';

part 'store_selected_conversation.g.dart';

abstract class StoreSelectedConversation extends Object
    with ReduxAction
    implements
        Built<StoreSelectedConversation, StoreSelectedConversationBuilder> {
  ConversationItem get item;

  StoreSelectedConversation._();

  factory StoreSelectedConversation(
          [void Function(StoreSelectedConversationBuilder) updates]) =
      _$StoreSelectedConversation;

  Object toJson() =>
      serializers.serializeWith(StoreSelectedConversation.serializer, this);

  static StoreSelectedConversation fromJson(String jsonString) =>
      serializers.deserializeWith(
          StoreSelectedConversation.serializer, json.decode(jsonString));

  static Serializer<StoreSelectedConversation> get serializer =>
      _$storeSelectedConversationSerializer;

  @override
  String toString() => 'STORE_SELECTED_CONVERSATION';
}
