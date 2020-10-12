library messages_page_data;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/navigation/page_data/page_data.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'messages_page_data.g.dart';

abstract class MessagesPageData
    implements PageData, Built<MessagesPageData, MessagesPageDataBuilder> {
  MessagesPageData._();

  factory MessagesPageData() = _$MessagesPageData._;

  Object toJson() =>
      serializers.serializeWith(MessagesPageData.serializer, this);

  static MessagesPageData fromJson(String jsonString) => serializers
      .deserializeWith(MessagesPageData.serializer, json.decode(jsonString));

  static Serializer<MessagesPageData> get serializer =>
      _$messagesPageDataSerializer;
}
