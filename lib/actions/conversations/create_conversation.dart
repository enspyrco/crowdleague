library create_conversation;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'create_conversation.g.dart';

abstract class CreateConversation extends Object
    with ReduxAction
    implements Built<CreateConversation, CreateConversationBuilder> {
  CreateConversation._();

  factory CreateConversation(
          [void Function(CreateConversationBuilder) updates]) =
      _$CreateConversation;

  Object toJson() =>
      serializers.serializeWith(CreateConversation.serializer, this);

  static CreateConversation fromJson(String jsonString) => serializers
      .deserializeWith(CreateConversation.serializer, json.decode(jsonString));

  static Serializer<CreateConversation> get serializer =>
      _$createConversationSerializer;

  @override
  String toString() => 'CREATE_CONVERSATION';
}
