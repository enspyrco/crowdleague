import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInWrapper {
  Future<AuthorizationCredentialAppleID> getAppleIDCredential() {
    return SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'co.enspyr.crowdleague1.auth-service',
        redirectUri: Uri.parse(
          'https://lumpy-spangled-rocket.glitch.me/callbacks/sign_in_with_apple',
        ),
      ),
    );
  }
}
