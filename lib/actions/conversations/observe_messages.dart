library observe_messages;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'observe_messages.g.dart';

abstract class ObserveMessages extends Object
    with ReduxAction
    implements Built<ObserveMessages, ObserveMessagesBuilder> {
  ObserveMessages._();

  factory ObserveMessages() = _$ObserveMessages;

  Object toJson() =>
      serializers.serializeWith(ObserveMessages.serializer, this);

  static ObserveMessages fromJson(String jsonString) => serializers
      .deserializeWith(ObserveMessages.serializer, json.decode(jsonString));

  static Serializer<ObserveMessages> get serializer =>
      _$observeMessagesSerializer;

  @override
  String toString() => 'OBSERVE_MESSAGES';
}
