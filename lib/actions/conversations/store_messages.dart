library store_messages;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/conversations/conversation/message.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'store_messages.g.dart';

abstract class StoreMessages extends Object
    with ReduxAction
    implements Built<StoreMessages, StoreMessagesBuilder> {
  BuiltList<Message> get messages;

  StoreMessages._();

  factory StoreMessages([void Function(StoreMessagesBuilder) updates]) =
      _$StoreMessages;

  Object toJson() => serializers.serializeWith(StoreMessages.serializer, this);

  static StoreMessages fromJson(String jsonString) => serializers
      .deserializeWith(StoreMessages.serializer, json.decode(jsonString));

  static Serializer<StoreMessages> get serializer => _$storeMessagesSerializer;

  @override
  String toString() => 'STORE_MESSAGES';
}
