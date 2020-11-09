library retrieve_new_conversation_suggestions;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'retrieve_new_conversation_suggestions.g.dart';

abstract class RetrieveNewConversationSuggestions extends Object
    with
        ReduxAction
    implements
        Built<RetrieveNewConversationSuggestions,
            RetrieveNewConversationSuggestionsBuilder> {
  RetrieveNewConversationSuggestions._();

  factory RetrieveNewConversationSuggestions() =
      _$RetrieveNewConversationSuggestions._;

  Object toJson() => serializers.serializeWith(
      RetrieveNewConversationSuggestions.serializer, this);

  static RetrieveNewConversationSuggestions fromJson(String jsonString) =>
      serializers.deserializeWith(RetrieveNewConversationSuggestions.serializer,
          json.decode(jsonString));

  static Serializer<RetrieveNewConversationSuggestions> get serializer =>
      _$retrieveNewConversationSuggestionsSerializer;

  @override
  String toString() => 'RETRIEVE_NEW_CONVERSATION_SUGGESTIONS';
}
