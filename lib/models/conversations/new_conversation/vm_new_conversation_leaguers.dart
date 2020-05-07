library vm_new_conversation_leaguers;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/app/serializers.dart';
import 'package:crowdleague/models/enums/new_conversation_page_leaguers_state.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';

part 'vm_new_conversation_leaguers.g.dart';

abstract class VmNewConversationLeaguers
    implements
        Built<VmNewConversationLeaguers, VmNewConversationLeaguersBuilder> {
  BuiltList<Leaguer> get leaguers;
  NewConversationPageLeaguersState get state;

  VmNewConversationLeaguers._();

  factory VmNewConversationLeaguers(
          [void Function(VmNewConversationLeaguersBuilder) updates]) =
      _$VmNewConversationLeaguers;

  Object toJson() =>
      serializers.serializeWith(VmNewConversationLeaguers.serializer, this);

  static VmNewConversationLeaguers fromJson(String jsonString) =>
      serializers.deserializeWith(
          VmNewConversationLeaguers.serializer, json.decode(jsonString));

  static Serializer<VmNewConversationLeaguers> get serializer =>
      _$vmNewConversationLeaguersSerializer;
}
