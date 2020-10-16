library leave_conversation;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'leave_conversation.g.dart';

abstract class LeaveConversation extends Object
    with ReduxAction
    implements Built<LeaveConversation, LeaveConversationBuilder> {
  String get conversationId;

  LeaveConversation._();

  factory LeaveConversation({@required String conversationId}) =
      _$LeaveConversation._;

  factory LeaveConversation.by() = _$LeaveConversation;

  Object toJson() =>
      serializers.serializeWith(LeaveConversation.serializer, this);

  static LeaveConversation fromJson(String jsonString) => serializers
      .deserializeWith(LeaveConversation.serializer, json.decode(jsonString));

  static Serializer<LeaveConversation> get serializer =>
      _$leaveConversationSerializer;

  @override
  String toString() => 'LEAVE_CONVERSATION: id=$conversationId';
}
