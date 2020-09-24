library update_conversation_page;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'update_conversation_page.g.dart';

abstract class UpdateConversationPage extends Object
    with ReduxAction
    implements Built<UpdateConversationPage, UpdateConversationPageBuilder> {
  String get messageText;

  UpdateConversationPage._();

  factory UpdateConversationPage(
          [void Function(UpdateConversationPageBuilder) updates]) =
      _$UpdateConversationPage;

  Object toJson() =>
      serializers.serializeWith(UpdateConversationPage.serializer, this);

  static UpdateConversationPage fromJson(String jsonString) =>
      serializers.deserializeWith(
          UpdateConversationPage.serializer, json.decode(jsonString));

  static Serializer<UpdateConversationPage> get serializer =>
      _$updateConversationPageSerializer;

  @override
  String toString() => 'UPDATE_CONVERSATION_PAGE';
}
