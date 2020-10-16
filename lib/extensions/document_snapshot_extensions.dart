import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/enums/processing_failure_type.dart';
import 'package:crowdleague/models/conversations/conversation_summary.dart';
import 'package:crowdleague/models/functions/processing_failure.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';

extension ConvertDocumentSnapshot on DocumentSnapshot {
  Leaguer toLeaguer() => Leaguer(
      uid: id,
      displayName: data()['displayName'] as String,
      photoURL: data()['photoURL'] as String ??
          'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y');

  ProcessingFailure toProcessingFailure() => ProcessingFailure(
      id: id,
      type: ProcessingFailureType.valueOf(data()['type'] as String),
      seen: data()['seen'] as bool ?? false,
      createdOn: data()['createdOn'] as DateTime,
      message: data()['message'] as String,
      data: data()['data'] as Object);

  ConversationSummary toConversationSummary() => ConversationSummary(
      conversationId: id,
      displayNames:
          BuiltList<String>.from(data()['displayNames'] as List<dynamic>),
      photoURLs: BuiltList<String>.from(data()['photoURLs'] as List<dynamic>),
      uids: BuiltList<String>.from(data()['uids'] as List<dynamic>));
}
