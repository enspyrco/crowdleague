import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/extensions/add_problem_extensions.dart';
import 'package:crowdleague/actions/conversations/store_selected_conversation.dart';
import 'package:crowdleague/actions/redux_action.dart';
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
}
