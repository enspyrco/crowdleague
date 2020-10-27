import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/actions/auth/clear_user_data.dart';
import 'package:crowdleague/actions/auth/store_auth_step.dart';
import 'package:crowdleague/actions/auth/store_user.dart';
import 'package:crowdleague/actions/auth/update_email_auth_options_page.dart';
import 'package:crowdleague/actions/navigation/remove_current_page.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/models/auth/user.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:mockito/mockito.dart';

class FakeAuthService extends Fake implements AuthService {
  StreamController<ReduxAction> controller;
  FakeAuthService() {
    controller = StreamController<ReduxAction>();
  }

  @override
  Stream<ReduxAction> emailSignInStream(String email, String password) async* {
    yield UpdateEmailAuthOptionsPage(step: AuthStep.signingInWithEmail);

    // Sign user in
    controller.add(StoreUser(
      user: User(
          id: 'id',
          email: 'email',
          displayName: 'name',
          photoURL: 'url',
          providers: BuiltList()),
    ));

    yield UpdateEmailAuthOptionsPage(step: AuthStep.waitingForInput);
    yield RemoveCurrentPage();
  }

  @override
  Stream<ReduxAction> get appleSignInStream async* {
    yield StoreAuthStep(step: AuthStep.signingInWithApple);
    yield StoreAuthStep(step: AuthStep.signingInWithFirebase);

    // Sign user in
    controller.add(StoreUser(
      user: User(
          id: 'id',
          email: 'email',
          displayName: 'name',
          photoURL: 'url',
          providers: BuiltList()),
    ));

    yield StoreAuthStep(step: AuthStep.waitingForInput);
    yield RemoveCurrentPage();
  }

  @override
  Stream<ReduxAction> get googleSignInStream async* {
    yield StoreAuthStep(step: AuthStep.signingInWithGoogle);
    yield StoreAuthStep(step: AuthStep.signingInWithFirebase);

    // Sign user in
    controller.add(StoreUser(
      user: User(
          id: 'id',
          email: 'email',
          displayName: 'name',
          photoURL: 'url',
          providers: BuiltList()),
    ));

    yield StoreAuthStep(step: AuthStep.waitingForInput);
    yield RemoveCurrentPage();
  }

  @override
  Future<ReduxAction> signOut() {
    controller.add(ClearUserData());
    return Future.value(null);
  }

  @override
  Stream<ReduxAction> get streamOfStateChanges {
    // controller.add(StoreUser(user: null));
    return controller.stream;
  }

  void close() {
    controller.close();
  }
}
