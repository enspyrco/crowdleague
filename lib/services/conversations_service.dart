import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/actions/conversations/store_conversation_items.dart';
import 'package:crowdleague/extensions/add_problem_extensions.dart';
import 'package:crowdleague/actions/conversations/store_selected_conversation.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/conversations/conversation_item.dart';
import 'package:crowdleague/models/enums/problem_type.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';

class ConversationsService {
  final Firestore firestore;

  ConversationsService({this.firestore});

  /// Returns a [Future] of either [StoreSelectedConversation] or [AddProblem]
  Future<ReduxAction> createConversation(
      String userId, BuiltList<Leaguer> leaguers) async {
    try {
      final displayNames = <String>[];
      final photoURLs = <String>[];
      final uids = <String>[];
      for (final leaguer in leaguers) {
        displayNames.add(leaguer.displayName);
        photoURLs.add(leaguer.photoUrl);
        uids.add(leaguer.uid);
      }

      final docRef =
          await firestore.collection('conversations').add(<String, dynamic>{
        'createdBy': userId,
        'createdOn': FieldValue.serverTimestamp(),
        'displayNames': displayNames,
        'photoURLs': photoURLs,
        'uids': uids
      });

      return StoreSelectedConversation((b) => b
        ..item.conversationId = docRef.documentID
        ..item.displayNames = ListBuilder(displayNames)
        ..item.photoURLs = ListBuilder(photoURLs)
        ..item.uids = ListBuilder(uids));
    } catch (error, trace) {
      return AddProblemObject.from(
          error, trace, ProblemType.createConversation);
    }
  }

  /// Returns a [Future] of either [StoreSelectedConversation] or [AddProblem]
  Future<ReduxAction> retrieveConversationItems(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('users/$userId/conversation-items')
          .getDocuments();

      final items = querySnapshot.documents.map<
          ConversationItem>((snapshot) => ConversationItem((b) => b
        ..conversationId = snapshot.data['conversationId'] as String
        ..displayNames.replace(
            List<String>.from(snapshot.data['displayNames'] as List<dynamic>))
        ..photoURLs.replace(
            List<String>.from(snapshot.data['photoURLs'] as List<dynamic>))
        ..uids.replace(
            List<String>.from(snapshot.data['uids'] as List<dynamic>))));

      return StoreConversationItems((b) => b..items.replace(items));
    } catch (error, trace) {
      return AddProblemObject.from(
          error, trace, ProblemType.createConversation);
    }
  }
}
