import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/actions/auth/clear_user_data.dart';
import 'package:crowdleague/actions/auth/store_user.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/auth/user.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:mockito/mockito.dart';

class FakeAuthService extends Fake implements AuthService {
  StreamController<ReduxAction> controller;
  FakeAuthService() {
    controller = StreamController<ReduxAction>();
  }

  @override
  Stream<ReduxAction> get appleSignInStream => throw UnimplementedError();

  @override
  Stream<ReduxAction> get googleSignInStream => throw UnimplementedError();

  @override
  Future<ReduxAction> signOut() {
    controller.add(ClearUserData());
    return Future.value(null);
  }

  @override
  Stream<ReduxAction> get streamOfStateChanges {
    controller.add(StoreUser(user: null));
    controller.add(StoreUser(
      user: User(
          id: 'id',
          email: 'email',
          displayName: 'name',
          photoURL: 'url',
          providers: BuiltList()),
    ));
    return controller.stream;
  }

  void close() {
    controller.close();
  }
}
