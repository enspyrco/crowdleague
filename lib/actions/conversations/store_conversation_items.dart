library store_conversation_items;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';
import 'package:crowdleague/models/conversations/conversation_item.dart';

part 'store_conversation_items.g.dart';

abstract class StoreConversationItems extends Object
    with ReduxAction
    implements Built<StoreConversationItems, StoreConversationItemsBuilder> {
  BuiltList<ConversationItem> get items;

  StoreConversationItems._();

  factory StoreConversationItems(
          [void Function(StoreConversationItemsBuilder) updates]) =
      _$StoreConversationItems;

  Object toJson() =>
      serializers.serializeWith(StoreConversationItems.serializer, this);

  static StoreConversationItems fromJson(String jsonString) =>
      serializers.deserializeWith(
          StoreConversationItems.serializer, json.decode(jsonString));

  static Serializer<StoreConversationItems> get serializer =>
      _$storeConversationItemsSerializer;

  @override
  String toString() => 'STORE_CONVERSATION_ITEMS';
}
