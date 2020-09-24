library conversation_summary;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'conversation_summary.g.dart';

abstract class ConversationSummary
    implements Built<ConversationSummary, ConversationSummaryBuilder> {
  String get conversationId;
  BuiltList<String> get uids;
  BuiltList<String> get photoURLs;
  BuiltList<String> get displayNames;

  ConversationSummary._();

  factory ConversationSummary(
          [void Function(ConversationSummaryBuilder) updates]) =
      _$ConversationSummary;

  Object toJson() =>
      serializers.serializeWith(ConversationSummary.serializer, this);

  static ConversationSummary fromJson(String jsonString) => serializers
      .deserializeWith(ConversationSummary.serializer, json.decode(jsonString));

  static Serializer<ConversationSummary> get serializer =>
      _$conversationSummarySerializer;
}
