import 'dart:async';

import 'package:crowdleague/actions/auth/clear_user_data.dart';
import 'package:crowdleague/actions/auth/store_user.dart';
import 'package:crowdleague/actions/redux_action.dart';
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
    controller.add(StoreUser((b) => b.user = null));
    controller.add(
      StoreUser((b) => b.user
        ..id = 'id'
        ..email = 'email'
        ..displayName = 'name'
        ..photoURL = 'url'),
    );
    return controller.stream;
  }

  void close() {
    controller.close();
  }
}
