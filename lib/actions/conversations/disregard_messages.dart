library disregard_messages;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'disregard_messages.g.dart';

abstract class DisregardMessages extends Object
    with ReduxAction
    implements Built<DisregardMessages, DisregardMessagesBuilder> {
  DisregardMessages._();

  factory DisregardMessages([void Function(DisregardMessagesBuilder) updates]) =
      _$DisregardMessages;

  Object toJson() =>
      serializers.serializeWith(DisregardMessages.serializer, this);

  static DisregardMessages fromJson(String jsonString) => serializers
      .deserializeWith(DisregardMessages.serializer, json.decode(jsonString));

  static Serializer<DisregardMessages> get serializer =>
      _$disregardMessagesSerializer;

  @override
  String toString() => 'DISREGARD_MESSAGES';
}
