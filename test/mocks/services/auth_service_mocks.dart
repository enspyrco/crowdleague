import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:mockito/mockito.dart';

class FakeAuthService extends Fake implements AuthService {
  @override
  // TODO: implement appleSignInStream
  Stream<ReduxAction> get appleSignInStream =>
      Stream.fromIterable([ReduxAction()]);

  @override
  // TODO: implement googleSignInStream
  Stream<ReduxAction> get googleSignInStream => throw UnimplementedError();

  @override
  Future<ReduxAction> signInWithEmail(String email, String password) {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<ReduxAction> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<ReduxAction> signUpWithEmail(String email, String password) async {
    // return Future.value(NavigatorPopAll());
  }

  @override
  // TODO: implement streamOfStateChanges
  Stream<ReduxAction> get streamOfStateChanges => Stream.fromIterable([]);
}

class MockAuthService extends Mock implements AuthService {
  // @override
  // Stream<ReduxAction> get appleSignInStream => Stream.fromIterable([]);
}
