import 'package:crowdleague/actions/navigation/navigator_pop_all.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/services/auth_service.dart';

class FakeAuthService implements AuthService {
  @override
  // TODO: implement appleSignInStream
  Stream<ReduxAction> get appleSignInStream => throw UnimplementedError();

  @override
  // TODO: implement googleSignInStream
  Stream<ReduxAction> get googleSignInStream => throw UnimplementedError();

  @override
  Future<ReduxAction> signInWithEmail(String email, String password) {
    return Future.value(NavigatorPopAll());
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
