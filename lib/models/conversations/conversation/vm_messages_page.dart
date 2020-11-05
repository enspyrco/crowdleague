library vm_messages_page;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/conversations/conversation/message.dart';
import 'package:crowdleague/models/conversations/conversation_summary.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'vm_messages_page.g.dart';

abstract class VmMessagesPage
    implements Built<VmMessagesPage, VmMessagesPageBuilder> {
  @nullable
  ConversationSummary get summary;
  BuiltList<Message> get messages;
  String get messageText;

  VmMessagesPage._();

  factory VmMessagesPage(
      {@required ConversationSummary summary,
      @required BuiltList<Message> messages,
      @required String messageText}) = _$VmMessagesPage._;

  factory VmMessagesPage.by([void Function(VmMessagesPageBuilder) updates]) =
      _$VmMessagesPage;

  Object toJson() => serializers.serializeWith(VmMessagesPage.serializer, this);

  static VmMessagesPage fromJson(String jsonString) => serializers
      .deserializeWith(VmMessagesPage.serializer, json.decode(jsonString));

  static Serializer<VmMessagesPage> get serializer =>
      _$vmMessagesPageSerializer;
}
