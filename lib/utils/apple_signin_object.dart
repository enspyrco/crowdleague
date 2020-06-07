import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInObject {
  Future<AuthorizationCredentialAppleID> startAuth() {
    return SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
  }
}
