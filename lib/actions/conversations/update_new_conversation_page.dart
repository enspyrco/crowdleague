library update_new_conversation_page;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';
import 'package:crowdleague/enums/new_conversation_page_leaguers_state.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';

part 'update_new_conversation_page.g.dart';

abstract class UpdateNewConversationPage extends Object
    with ReduxAction
    implements
        Built<UpdateNewConversationPage, UpdateNewConversationPageBuilder> {
  @nullable
  NewConversationPageLeaguersState get state;
  @nullable
  Leaguer get selection;

  UpdateNewConversationPage._();

  factory UpdateNewConversationPage(
          [void Function(UpdateNewConversationPageBuilder) updates]) =
      _$UpdateNewConversationPage;

  Object toJson() =>
      serializers.serializeWith(UpdateNewConversationPage.serializer, this);

  static UpdateNewConversationPage fromJson(String jsonString) =>
      serializers.deserializeWith(
          UpdateNewConversationPage.serializer, json.decode(jsonString));

  static Serializer<UpdateNewConversationPage> get serializer =>
      _$updateNewConversationPageSerializer;

  @override
  String toString() => 'UPDATE_NEW_CONVERSATION_PAGE';
}
