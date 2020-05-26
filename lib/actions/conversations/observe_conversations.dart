library observe_conversations;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'observe_conversations.g.dart';

abstract class ObserveConversations extends Object
    with ReduxAction
    implements Built<ObserveConversations, ObserveConversationsBuilder> {
  ObserveConversations._();

  factory ObserveConversations(
          [void Function(ObserveConversationsBuilder) updates]) =
      _$ObserveConversations;

  Object toJson() =>
      serializers.serializeWith(ObserveConversations.serializer, this);

  static ObserveConversations fromJson(String jsonString) =>
      serializers.deserializeWith(
          ObserveConversations.serializer, json.decode(jsonString));

  static Serializer<ObserveConversations> get serializer =>
      _$observeConversationsSerializer;

  @override
  String toString() => 'OBSERVE_CONVERSATIONS';
}
