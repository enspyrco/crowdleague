import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:crowdleague/models/actions/clear_user_data.dart';
import 'package:crowdleague/models/actions/redux_action.dart';
import 'package:crowdleague/models/actions/store_auth_step.dart';
import 'package:crowdleague/models/actions/store_user.dart';
import 'package:crowdleague/models/enums/problem_type.dart';
import 'package:crowdleague/utils/apple_signin_object.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:crowdleague/extensions/extensions.dart';

class AuthService {
  AuthService(this._fireAuth, this._googleSignIn, this._appleSignIn);

  final FirebaseAuth _fireAuth;
  final GoogleSignIn _googleSignIn;
  final AppleSignInObject _appleSignIn;

  // Map FirebaseUser objects emitted by FirebaseAuth to a StoreUser action,
  // which can be dispatched by the store.
  // If the FirebaseUser or the uid field is null, create an empty StoreUser
  // object that will set the user field of the AppState to null.
  Stream<ReduxAction> get streamOfStateChanges {
    return _fireAuth.onAuthStateChanged.map(
      (FirebaseUser fireUser) => (fireUser == null || fireUser.uid == null)
          ? ClearUserData()
          : StoreUser((b) => b..user.replace(fireUser.toUser())),
    );
  }

  Stream<ReduxAction> get googleSignInStream async* {
    // signal to change UI
    yield StoreAuthStep((b) => b..step = 1);

    try {
      final googleUser = await _googleSignIn.signIn();

      // if the user canceled signin, an error is thrown but it gets swallowed
      // by the signIn() method so we need to reset the UI and close the stream
      if (googleUser == null) {
        yield StoreAuthStep((b) => b..step = 0);
        return;
      }

      // signal to change UI
      yield StoreAuthStep((b) => b..step = 2);

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      /// the auth info will be picked up by the listener on [onAuthStateChanged]
      /// and emitted by [streamOfStateChanges]
      await _fireAuth.signInWithCredential(credential);

      // we are signed in so reset the UI
      yield StoreAuthStep((b) => b..step = 0);
    } catch (error, trace) {
      // reset the UI and display an alert

      yield StoreAuthStep((b) => b..step = 0);
      // errors with code kSignInCanceledError are swallowed by the
      // GoogleSignIn.signIn() method so we can assume anything caught here
      // is a problem and send to the store for display
      yield AddProblemObject.from(error, trace, ProblemType.googleSignIn);
    }
  }

  Stream<ReduxAction> get appleSignInStream async* {
    // signal to change UI
    yield StoreAuthStep((b) => b..step = 1);

    try {
      final result = await _appleSignIn.startAuth();

      switch (result.status) {
        case AuthorizationStatus.authorized:
          // signal to change UI
          yield StoreAuthStep((b) => b..step = 2);

          // retrieve the apple credential and convert to oauth credential
          final appleIdCredential = result.credential;
          final oAuthProvider = OAuthProvider(providerId: 'apple.com');
          final credential = oAuthProvider.getCredential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken),
            accessToken:
                String.fromCharCodes(appleIdCredential.authorizationCode),
          );

          // use the credential to sign in to firebase
          await FirebaseAuth.instance.signInWithCredential(credential);

          // we are signed in so reset the UI
          yield StoreAuthStep((b) => b..step = 0);

          break;
        case AuthorizationStatus.error:
          throw result.error;
          break;

        case AuthorizationStatus.cancelled:
          yield StoreAuthStep((b) => b..step = 0);
          break;
      }
    } catch (error, trace) {
      // reset the UI and display an alert

      yield StoreAuthStep((b) => b..step = 0);
      // any specific errors are caught and dealt with so we can assume
      // anything caught here is a problem and send to the store for display
      yield AddProblemObject.from(error, trace, ProblemType.appleSignIn);
    }
  }

  /// Tries to sign in a user with the given email address and password.
  ///
  /// If successful, it also signs the user into the app and updates
  /// the [onAuthStateChanged] stream.
  ///
  /// Errors:
  ///
  ///  * `ERROR_INVALID_EMAIL` - If the [email] address is malformed.
  ///  * `ERROR_WRONG_PASSWORD` - If the [password] is wrong.
  ///  * `ERROR_USER_NOT_FOUND` - If there is no user corresponding to the given [email] address, or if the user has been deleted.
  ///  * `ERROR_USER_DISABLED` - If the user has been disabled (for example, in the Firebase console)
  ///  * `ERROR_TOO_MANY_REQUESTS` - If there was too many attempts to sign in as this user.
  ///  * `ERROR_OPERATION_NOT_ALLOWED` - Indicates that Email & Password accounts are not enabled.
  Future<ReduxAction> signInWithEmail(String email, String password) async {
    try {
      final AuthResult _ = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // successful sign in will update the onAuthStateChanged stream
      // so there is no point in doing anything here
      return null;
    } catch (error, trace) {
      return AddProblemObject.from(error, trace, ProblemType.emailSignIn);
    }
  }

  /// Tries to create a new user account with the given email address and password.
  ///
  /// If successful, it also signs the user in into the app and updates
  /// the [onAuthStateChanged] stream.
  ///
  /// Errors:
  ///
  ///  * `ERROR_WEAK_PASSWORD` - If the password is not strong enough.
  ///  * `ERROR_INVALID_EMAIL` - If the email address is malformed.
  ///  * `ERROR_EMAIL_ALREADY_IN_USE` - If the email is already in use by a different account.
  Future<ReduxAction> signUpWithEmail(String email, String password) async {
    try {
      final AuthResult _ = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // successful sign in will update the onAuthStateChanged stream
      // so there is no point in doing anything here
      return null;
    } catch (error, trace) {
      return AddProblemObject.from(error, trace, ProblemType.emailSignUp);
    }
  }

  Future<ReduxAction> signOut() {
    try {
      FirebaseAuth.instance.signOut();
      _googleSignIn.signOut();
      // TODO: add sign out for sign in with apple provider
      // see Issue #6 https://github.com/nickmeinhold/crowdleague_public/issues/6
    } catch (error, trace) {
      return AddProblemFuture.from(error, trace, ProblemType.signOut);
    }

    // we let the AuthStateObserver dispatch a ClearUserData action when it
    // observes the relevant event
    return null;
  }
}
