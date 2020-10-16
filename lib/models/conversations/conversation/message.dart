library message;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'message.g.dart';

abstract class Message implements Built<Message, MessageBuilder> {
  String get text;

  Message._();

  factory Message({@required String text}) = _$Message._;

  factory Message.by([void Function(MessageBuilder) updates]) = _$Message;

  Object toJson() => serializers.serializeWith(Message.serializer, this);

  static Message fromJson(String jsonString) =>
      serializers.deserializeWith(Message.serializer, json.decode(jsonString));

  static Serializer<Message> get serializer => _$messageSerializer;
}
