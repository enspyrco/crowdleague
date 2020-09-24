library save_message;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'save_message.g.dart';

abstract class SaveMessage extends Object
    with ReduxAction
    implements Built<SaveMessage, SaveMessageBuilder> {
  SaveMessage._();

  factory SaveMessage([void Function(SaveMessageBuilder) updates]) =
      _$SaveMessage;

  Object toJson() => serializers.serializeWith(SaveMessage.serializer, this);

  static SaveMessage fromJson(String jsonString) => serializers.deserializeWith(
      SaveMessage.serializer, json.decode(jsonString));

  static Serializer<SaveMessage> get serializer => _$saveMessageSerializer;

  @override
  String toString() => 'SAVE_MESSAGE';
}
