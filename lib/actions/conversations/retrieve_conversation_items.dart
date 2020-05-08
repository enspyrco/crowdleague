library retrieve_conversation_items;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'retrieve_conversation_items.g.dart';

abstract class RetrieveConversationItems extends Object
    with ReduxAction
    implements
        Built<RetrieveConversationItems, RetrieveConversationItemsBuilder> {
  RetrieveConversationItems._();

  factory RetrieveConversationItems(
          [void Function(RetrieveConversationItemsBuilder) updates]) =
      _$RetrieveConversationItems;

  Object toJson() =>
      serializers.serializeWith(RetrieveConversationItems.serializer, this);

  static RetrieveConversationItems fromJson(String jsonString) =>
      serializers.deserializeWith(
          RetrieveConversationItems.serializer, json.decode(jsonString));

  static Serializer<RetrieveConversationItems> get serializer =>
      _$retrieveConversationItemsSerializer;

  @override
  String toString() => 'RETRIEVE_CONVERSATION_ITEMS';
}
