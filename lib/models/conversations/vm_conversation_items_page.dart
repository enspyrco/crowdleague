library vm_conversation_items_page;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';
import 'package:crowdleague/models/conversations/conversation_item.dart';

part 'vm_conversation_items_page.g.dart';

abstract class VmConversationItemsPage extends Object
    with ReduxAction
    implements Built<VmConversationItemsPage, VmConversationItemsPageBuilder> {
  BuiltList<ConversationItem> get items;

  VmConversationItemsPage._();

  factory VmConversationItemsPage(
          [void Function(VmConversationItemsPageBuilder) updates]) =
      _$VmConversationItemsPage;

  Object toJson() =>
      serializers.serializeWith(VmConversationItemsPage.serializer, this);

  static VmConversationItemsPage fromJson(String jsonString) =>
      serializers.deserializeWith(
          VmConversationItemsPage.serializer, json.decode(jsonString));

  static Serializer<VmConversationItemsPage> get serializer =>
      _$vmConversationItemsPageSerializer;

  @override
  String toString() => 'VM_CONVERSATION_ITEMS_PAGE';
}
