library vm_new_conversation_page;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/conversations/new_conversation/vm_new_conversation_selections.dart';
import 'package:crowdleague/models/conversations/new_conversation/vm_new_conversation_suggestions.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'vm_new_conversation_page.g.dart';

abstract class VmNewConversationPage
    implements Built<VmNewConversationPage, VmNewConversationPageBuilder> {
  VmNewConversationSuggestions get suggestions;
  VmNewConversationSelections get selections;

  VmNewConversationPage._();

  factory VmNewConversationPage(
          {@required VmNewConversationSuggestions suggestions,
          @required VmNewConversationSelections selections}) =
      _$VmNewConversationPage._;

  factory VmNewConversationPage.by(
          [void Function(VmNewConversationPageBuilder) updates]) =
      _$VmNewConversationPage;

  static VmNewConversationPageBuilder initBuilder() =>
      VmNewConversationPageBuilder()..suggestions.waiting = false;

  Object toJson() =>
      serializers.serializeWith(VmNewConversationPage.serializer, this);

  static VmNewConversationPage fromJson(String jsonString) =>
      serializers.deserializeWith(
          VmNewConversationPage.serializer, json.decode(jsonString));

  static Serializer<VmNewConversationPage> get serializer =>
      _$vmNewConversationPageSerializer;
}
