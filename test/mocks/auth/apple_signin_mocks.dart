import 'package:crowdleague/utils/wrappers/apple_signin_wrapper.dart';
import 'package:mockito/mockito.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class MockAppleSignIn extends Mock implements AppleSignInWrapper {}

class FakeAppleSignIn extends Fake implements AppleSignInWrapper {
  @override
  Future<AuthorizationCredentialAppleID> getAppleIDCredential() {
    final result = AuthorizationCredentialAppleID(
        authorizationCode: 'code',
        identityToken: 'token',
        familyName: 'fname',
        givenName: 'gname',
        email: 'email',
        state: 'state',
        userIdentifier: 'id');
    return Future.value(result);
  }
}

// When the user cancels during the signin process, startAuth throws AuthorizationErrorCode
class FakeAppleSignInCancels extends Fake implements AppleSignInWrapper {
  @override
  Future<AuthorizationCredentialAppleID> getAppleIDCredential() {
    throw SignInWithAppleAuthorizationException(
        code: AuthorizationErrorCode.canceled, message: 'message');
  }
}

class FakeAppleSignInThrows extends Fake implements AppleSignInWrapper {
  @override
  Future<AuthorizationCredentialAppleID> getAppleIDCredential() {
    throw Exception('AppleSignIn.signIn');
  }
}
