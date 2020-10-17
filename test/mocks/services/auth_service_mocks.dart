import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:mockito/mockito.dart';

class FakeAuthService extends Fake implements AuthService {
  @override
  Stream<ReduxAction> get appleSignInStream =>
      Stream.fromIterable([ReduxAction()]);

  @override
  Stream<ReduxAction> get googleSignInStream => throw UnimplementedError();

  @override
  Future<ReduxAction> signOut() {
    throw UnimplementedError();
  }

  @override
  Stream<ReduxAction> get streamOfStateChanges => Stream.fromIterable([]);
}

class MockAuthService extends Mock implements AuthService {}
