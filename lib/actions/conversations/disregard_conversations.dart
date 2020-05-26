library disregard_conversations;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'disregard_conversations.g.dart';

abstract class DisregardConversations extends Object
    with ReduxAction
    implements Built<DisregardConversations, DisregardConversationsBuilder> {
  DisregardConversations._();

  factory DisregardConversations(
          [void Function(DisregardConversationsBuilder) updates]) =
      _$DisregardConversations;

  Object toJson() =>
      serializers.serializeWith(DisregardConversations.serializer, this);

  static DisregardConversations fromJson(String jsonString) =>
      serializers.deserializeWith(
          DisregardConversations.serializer, json.decode(jsonString));

  static Serializer<DisregardConversations> get serializer =>
      _$disregardConversationsSerializer;

  @override
  String toString() => 'DISREGARD_CONVERSATIONS';
}
