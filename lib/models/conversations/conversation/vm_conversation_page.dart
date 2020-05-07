library vm_conversation_page;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/app/serializers.dart';
import 'package:crowdleague/models/conversations/conversation_item.dart';

part 'vm_conversation_page.g.dart';

abstract class VmConversationPage
    implements Built<VmConversationPage, VmConversationPageBuilder> {
  @nullable
  ConversationItem get item;

  VmConversationPage._();

  factory VmConversationPage(
          [void Function(VmConversationPageBuilder) updates]) =
      _$VmConversationPage;

  Object toJson() =>
      serializers.serializeWith(VmConversationPage.serializer, this);

  static VmConversationPage fromJson(String jsonString) => serializers
      .deserializeWith(VmConversationPage.serializer, json.decode(jsonString));

  static Serializer<VmConversationPage> get serializer =>
      _$vmConversationPageSerializer;
}
