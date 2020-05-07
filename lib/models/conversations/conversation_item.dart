library conversation_item;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'conversation_item.g.dart';

abstract class ConversationItem
    implements Built<ConversationItem, ConversationItemBuilder> {
  String get conversationId;
  BuiltList<String> get uids;
  BuiltList<String> get photoURLs;
  BuiltList<String> get displayNames;

  ConversationItem._();

  factory ConversationItem([void Function(ConversationItemBuilder) updates]) =
      _$ConversationItem;

  Object toJson() =>
      serializers.serializeWith(ConversationItem.serializer, this);

  static ConversationItem fromJson(String jsonString) => serializers
      .deserializeWith(ConversationItem.serializer, json.decode(jsonString));

  static Serializer<ConversationItem> get serializer =>
      _$conversationItemSerializer;
}
