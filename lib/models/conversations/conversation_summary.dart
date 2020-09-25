library conversation_summary;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'conversation_summary.g.dart';

abstract class ConversationSummary
    implements Built<ConversationSummary, ConversationSummaryBuilder> {
  String get conversationId;
  BuiltList<String> get uids;
  BuiltList<String> get photoURLs;
  BuiltList<String> get displayNames;

  ConversationSummary._();

  factory ConversationSummary(
      {@required String conversationId,
      @required BuiltList<String> uids,
      @required BuiltList<String> photoURLs,
      @required BuiltList<String> displayNames}) = _$ConversationSummary._;

  factory ConversationSummary.by(
          [void Function(ConversationSummaryBuilder) updates]) =
      _$ConversationSummary;

  Object toJson() =>
      serializers.serializeWith(ConversationSummary.serializer, this);

  static ConversationSummary fromJson(String jsonString) => serializers
      .deserializeWith(ConversationSummary.serializer, json.decode(jsonString));

  static Serializer<ConversationSummary> get serializer =>
      _$conversationSummarySerializer;
}
