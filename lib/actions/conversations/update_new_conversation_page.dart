library update_new_conversation_page;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'update_new_conversation_page.g.dart';

abstract class UpdateNewConversationPage extends Object
    with ReduxAction
    implements
        Built<UpdateNewConversationPage, UpdateNewConversationPageBuilder> {
  /// The state is either waiting or ready, used for showing apprpriate UI
  @nullable
  bool get waiting;

  /// A single selection that will be added to selections
  @nullable
  Leaguer get selection;

  /// A list that will replace the current suggestions list
  @nullable
  BuiltList<Leaguer> get suggestions;

  UpdateNewConversationPage._();

  factory UpdateNewConversationPage(
      {bool waiting,
      Leaguer selection,
      BuiltList<Leaguer> suggestions}) = _$UpdateNewConversationPage._;

  factory UpdateNewConversationPage.by(
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
