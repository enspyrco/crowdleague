import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/actions/conversations/store_selected_conversation.dart';
import 'package:crowdleague/actions/leaguers/store_leaguers.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';
import 'package:crowdleague/utils/firestore_subscriptions.dart';
import 'package:redux/redux.dart';

class DatabaseService {
  /// The [Firestore] instance, the current implementation of the database
  final Firestore _firestore;

  /// The [FirestoreSubscriptions] object holds the subscriptions to the
  /// firestore streams, used to cancel streams when we want to stop listening
  /// to events in the firestore
  final FirestoreSubscriptions _firestoreSubscriptions =
      FirestoreSubscriptions();

  /// The [_storeController] is connected to the redux [Store] and is used
  /// by the [DatabaseService] to add actions to the stream where they will
  /// be dispatched by the store
  final StreamController<ReduxAction> _storeController =
      StreamController<ReduxAction>();

  /// The stream of the [_storeController] is used just once on app load, to
  /// connect the [_storeController] to the redux [Store]
  Stream<ReduxAction> get storeStream => _storeController.stream;

  DatabaseService(Firestore firestore) : _firestore = firestore;

  //////////////////////////////////////////////////////////////////////////////
  /// CONVERSATIONS
  //////////////////////////////////////////////////////////////////////////////

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
          await _firestore.collection('/conversations/').add(<String, dynamic>{
        'createdBy': userId,
        'createdOn': FieldValue.serverTimestamp(),
        'displayNames': displayNames,
        'photoURLs': photoURLs,
        'uids': uids
      });

      return StoreSelectedConversation((b) => b
        ..summary.conversationId = docRef.documentID
        ..summary.displayNames = ListBuilder(displayNames)
        ..summary.photoURLs = ListBuilder(photoURLs)
        ..summary.uids = ListBuilder(uids));
    } catch (error, trace) {
      return AddProblemObject.from(
          error, trace, ProblemType.createConversation);
    }
  }

  /// We listen for changes in the conversations collection and try to convert
  /// each updated collection to a [StoreConversationSummaries] action.
  ///
  /// The action is added to the [_storeController] or if there was a problem,
  /// an [AddProblem] action is added.
  void observeConversations(String userId) {
    try {
      _firestoreSubscriptions.conversations =
          _firestore.connectToConversations(userId, _storeController);
    } catch (error, trace) {
      _storeController.add(
          AddProblemObject.from(error, trace, ProblemType.createConversation));
    }
  }

  void disregardConversations() {
    try {
      _firestoreSubscriptions.conversations?.cancel();
    } catch (error, trace) {
      _storeController.add(AddProblemObject.from(
          error, trace, ProblemType.disregardConversations));
    }
  }

  void saveMessage(Store<AppState> store) async {
    try {
      // the message saved to firestore will be put in the app state via the
      // observeMessages function
      await _firestore
          .collection(
              '/conversations/${store.state.conversationPage.summary.conversationId}/messages/')
          .add(<String, dynamic>{
        'authorId': store.state.user.id,
        'text': store.state.conversationPage.messageText,
        'timestamp': FieldValue.serverTimestamp()
      });
    } catch (error, trace) {
      store.dispatch(
          AddProblemObject.from(error, trace, ProblemType.saveMessage));
    }
  }

  /// We listen for changes in the messages collection and add the updated
  /// entries to the stream connected to the store.
  void observeMessages(String conversationId) {
    try {
      _firestoreSubscriptions.messages =
          _firestore.connectToMessages(conversationId, _storeController);
    } catch (error, trace) {
      _storeController.add(
          AddProblemObject.from(error, trace, ProblemType.observeMessages));
    }
  }

  /// cancels the subscription or dispatches an AddProblem action
  void disregardMessages(Store<AppState> store) async {
    try {
      await _firestoreSubscriptions.messages?.cancel();
    } catch (error, trace) {
      store.dispatch(
          AddProblemObject.from(error, trace, ProblemType.disregardMessages));
    }
  }

  Future<void> leaveConversation(String userId, String conversationId) {
    return _firestore
        .document('/conversations/$conversationId/leave/$userId')
        .setData(<String, dynamic>{'timestamp': FieldValue.serverTimestamp()});
  }

  //////////////////////////////////////////////////////////////////////////////
  /// LEAGUERS
  //////////////////////////////////////////////////////////////////////////////

  Future<ReduxAction> get retrieveLeaguers async {
    try {
      final collection = await _firestore.collection('/users/');
      final snapshot = await collection.getDocuments();
      final leaguers = snapshot.documents.map<
          Leaguer>((user) => Leaguer((b) => b
        ..uid = user.data['uid'] as String
        ..displayName =
            user.data['name'] as String ?? user.data['uid'] as String
        ..photoUrl = user.data['photoUrl'] as String ??
            'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y'));

      // TODO: this is for testing and can be removed when there is enough real data
      // final vm = VmNewConversationLeaguers.fromJson(leaguers_data_json);
      // return StoreLeaguers((b) => b..leaguers.replace(vm.leaguers));

      return StoreLeaguers((b) => b..leaguers.replace(leaguers));
    } catch (error, trace) {
      return AddProblemObject.from(error, trace, ProblemType.retrieveLeaguers);
    }
  }

  void observeProfilePics(String userId) {
    try {
      // - create a stream from the firestore
      // - listen to the stream and add events to the stream_controller
      // - store the subscription so the stream from the firestore can be
      // cancelled
      _firestoreSubscriptions.profilePics =
          _firestore.connectToProfilePics(userId, _storeController);
    } catch (error, trace) {
      _storeController.add(
          AddProblemObject.from(error, trace, ProblemType.observeProfilePics));
    }
  }

  /// cancels the subscription or dispatches an AddProblem action
  void disregardProfilePics() async {
    try {
      await _firestoreSubscriptions.profilePics?.cancel();
    } catch (error, trace) {
      _storeController.add(AddProblemObject.from(
          error, trace, ProblemType.disregardProfilePics));
    }
  }

  ///
  void observeProfile(String userId) {
    try {
      _firestoreSubscriptions.profile =
          _firestore.connectToProfile(userId, _storeController);
    } catch (error, trace) {
      _storeController
          .add(AddProblemObject.from(error, trace, ProblemType.observeProfile));
    }
  }

  /// cancels the subscription or dispatches an AddProblem action
  void disregardProfile() async {
    try {
      await _firestoreSubscriptions.profile?.cancel();
    } catch (error, trace) {
      _storeController.add(
          AddProblemObject.from(error, trace, ProblemType.disregardProfile));
    }
  }
}

// TODO: this is for testing and can be removed when there is enough real data
final leaguers_data_json = '''
{"leaguers":[{"id":"1","name":"Andrea Jonus","photoUrl":"https://lh3.googleusercontent.com/a-/AOh14GgpUMMFMDDMSfOSCUunGMkJdJ5TPkmbrU-cQEo6yZk=s96-c"},{"id":"2","name":"Nick Meinhold","photoUrl":"https://lh3.googleusercontent.com/a-/AOh14GjI7gPhw0micPDoMr3PWmsRzksx0kc-z47wMKCpJQ=s96-c"},{"id":"3","name":"David Micallef","photoUrl":"https://lh3.googleusercontent.com/a-/AOh14GgcLuTiYf_wdIIMAw5CPaBDQowtVTHczbRV8eZrIQ=s96-c"}],"state":"ready"}
''';
