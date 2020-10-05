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
    // TODO: implement createConversation
    throw UnimplementedError();
  }

  @override
  Future<ReduxAction> deleteProfilePic(String userId, String picId) {
    // TODO: implement deleteProfilePic
    throw UnimplementedError();
  }

  @override
  void disregardConversations() {
    // TODO: implement disregardConversations
  }

  @override
  void disregardMessages(Store<AppState> store) {
    // TODO: implement disregardMessages
  }

  @override
  void disregardProfile() {
    // TODO: implement disregardProfile
  }

  @override
  void disregardProfilePics() {
    // TODO: implement disregardProfilePics
  }

  @override
  Future<void> leaveConversation(String userId, String conversationId) {
    // TODO: implement leaveConversation
    throw UnimplementedError();
  }

  @override
  void observeConversations(String userId) {
    // TODO: implement observeConversations
  }

  @override
  void observeMessages(String conversationId) {
    // TODO: implement observeMessages
  }

  @override
  void observeProcessingFailures(String userId) {
    // TODO: implement observeProcessingFailures
  }

  @override
  void observeProfile(String userId) {
    // TODO: implement observeProfile
  }

  @override
  void observeProfilePics(String userId) {
    // TODO: implement observeProfilePics
  }

  @override
  // TODO: implement retrieveLeaguers
  Future<ReduxAction> get retrieveLeaguers => throw UnimplementedError();

  @override
  void saveMessage(Store<AppState> store) {
    // TODO: implement saveMessage
  }

  @override
  Stream<ReduxAction> get storeStream => StreamController<ReduxAction>().stream;

  @override
  Future<ReduxAction> updateLeaguer(String userId, String picId) {
    // TODO: implement updateLeaguer
    throw UnimplementedError();
  }
}
