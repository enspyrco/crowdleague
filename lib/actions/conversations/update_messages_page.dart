library update_messages_page;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'update_messages_page.g.dart';

abstract class UpdateMessagesPage extends Object
    with ReduxAction
    implements Built<UpdateMessagesPage, UpdateMessagesPageBuilder> {
  String get messageText;

  UpdateMessagesPage._();

  factory UpdateMessagesPage({@required String messageText}) =
      _$UpdateMessagesPage._;

  factory UpdateMessagesPage.by(
          [void Function(UpdateMessagesPageBuilder) updates]) =
      _$UpdateMessagesPage;

  Object toJson() =>
      serializers.serializeWith(UpdateMessagesPage.serializer, this);

  static UpdateMessagesPage fromJson(String jsonString) => serializers
      .deserializeWith(UpdateMessagesPage.serializer, json.decode(jsonString));

  static Serializer<UpdateMessagesPage> get serializer =>
      _$updateMessagesPageSerializer;

  @override
  String toString() => 'UPDATE_MESSAGES_PAGE';
}
