library new_conversation_page_data;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/navigation/page_data/page_data.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'new_conversation_page_data.g.dart';

abstract class NewConversationPageData
    implements
        PageData,
        Built<NewConversationPageData, NewConversationPageDataBuilder> {
  NewConversationPageData._();

  factory NewConversationPageData() = _$NewConversationPageData._;

  Object toJson() =>
      serializers.serializeWith(NewConversationPageData.serializer, this);

  static NewConversationPageData fromJson(String jsonString) =>
      serializers.deserializeWith(
          NewConversationPageData.serializer, json.decode(jsonString));

  static Serializer<NewConversationPageData> get serializer =>
      _$newConversationPageDataSerializer;
}
