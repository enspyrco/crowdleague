import 'dart:async';

import 'package:built_collection/src/list.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:redux/src/store.dart';

class FakeDatabaseService implements DatabaseService {
  @override
  Future<ReduxAction> createConversation(
      String userId, BuiltList<Leaguer> leaguers) {
    throw UnimplementedError();
  }

  @override
  Future<ReduxAction> deleteProfilePic(String userId, String picId) {
    throw UnimplementedError();
  }

  @override
  void disregardConversations() {}

  @override
  void disregardMessages(Store<AppState> store) {}

  @override
  void disregardProfile() {}

  @override
  void disregardProfilePics() {}

  @override
  Future<void> leaveConversation(String userId, String conversationId) {
    throw UnimplementedError();
  }

  @override
  void observeConversations(String userId) {}

  @override
  void observeMessages(String conversationId) {}

  @override
  void observeProcessingFailures(String userId) {}

  @override
  void observeProfile(String userId) {}

  @override
  void observeProfilePics(String userId) {}

  @override
  Future<ReduxAction> get retrieveNewConversationSuggestions =>
      throw UnimplementedError();

  @override
  void saveMessage(Store<AppState> store) {}

  @override
  Stream<ReduxAction> get storeStream => StreamController<ReduxAction>().stream;

  @override
  Future<ReduxAction> updateLeaguer(String userId, String picId) {
    throw UnimplementedError();
  }
}
