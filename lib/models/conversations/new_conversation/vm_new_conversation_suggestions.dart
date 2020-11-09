library vm_new_conversation_suggestions;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'vm_new_conversation_suggestions.g.dart';

abstract class VmNewConversationSuggestions
    implements
        Built<VmNewConversationSuggestions,
            VmNewConversationSuggestionsBuilder> {
  BuiltList<Leaguer> get leaguers;
  bool get waiting;

  VmNewConversationSuggestions._();

  factory VmNewConversationSuggestions(
      {@required BuiltList<Leaguer> leaguers,
      @required bool waiting}) = _$VmNewConversationSuggestions._;

  factory VmNewConversationSuggestions.by(
          [void Function(VmNewConversationSuggestionsBuilder) updates]) =
      _$VmNewConversationSuggestions;

  Object toJson() =>
      serializers.serializeWith(VmNewConversationSuggestions.serializer, this);

  static VmNewConversationSuggestions fromJson(String jsonString) =>
      serializers.deserializeWith(
          VmNewConversationSuggestions.serializer, json.decode(jsonString));

  static Serializer<VmNewConversationSuggestions> get serializer =>
      _$vmNewConversationSuggestionsSerializer;
}
