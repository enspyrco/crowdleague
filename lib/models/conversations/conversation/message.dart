library message;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'message.g.dart';

abstract class Message implements Built<Message, MessageBuilder> {
  String get text;

  Message._();

  factory Message([void Function(MessageBuilder) updates]) = _$Message;

  Object toJson() => serializers.serializeWith(Message.serializer, this);

  static Message fromJson(String jsonString) =>
      serializers.deserializeWith(Message.serializer, json.decode(jsonString));

  static Serializer<Message> get serializer => _$messageSerializer;
}
