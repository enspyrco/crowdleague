library vm_new_conversation_page;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/enums/new_conversation_page_leaguers_state.dart';
import 'package:crowdleague/models/conversations/new_conversation/vm_new_conversation_leaguers.dart';
import 'package:crowdleague/models/conversations/new_conversation/vm_new_conversation_selections.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'vm_new_conversation_page.g.dart';

abstract class VmNewConversationPage
    implements Built<VmNewConversationPage, VmNewConversationPageBuilder> {
  VmNewConversationLeaguers get leaguersVM;
  VmNewConversationSelections get selectionsVM;

  VmNewConversationPage._();

  factory VmNewConversationPage(
          {@required VmNewConversationLeaguers leaguersVM,
          @required VmNewConversationSelections selectionsVM}) =
      _$VmNewConversationPage._;

  factory VmNewConversationPage.by(
          [void Function(VmNewConversationPageBuilder) updates]) =
      _$VmNewConversationPage;

  static VmNewConversationPageBuilder initBuilder() =>
      VmNewConversationPageBuilder()
        ..leaguersVM.state = NewConversationPageLeaguersState.ready;

  Object toJson() =>
      serializers.serializeWith(VmNewConversationPage.serializer, this);

  static VmNewConversationPage fromJson(String jsonString) =>
      serializers.deserializeWith(
          VmNewConversationPage.serializer, json.decode(jsonString));

  static Serializer<VmNewConversationPage> get serializer =>
      _$vmNewConversationPageSerializer;
}
