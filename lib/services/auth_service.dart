import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/actions/auth/clear_user_data.dart';
import 'package:crowdleague/actions/auth/store_auth_step.dart';
import 'package:crowdleague/actions/auth/store_user.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/actions/navigation/navigator_pop_all.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/utils/apple_signin_object.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _fireAuth;
  final GoogleSignIn _googleSignIn;
  final AppleSignInObject _appleSignIn;

  AuthService(this._fireAuth, this._googleSignIn, this._appleSignIn);

  // Map FirebaseUser objects emitted by FirebaseAuth to a StoreUser action,
  // which can be dispatched by the store.
  // If the FirebaseUser or the uid field is null, create an empty StoreUser
  // object that will set the user field of the AppState to null.
  Stream<ReduxAction> get streamOfStateChanges {
    return _fireAuth.onAuthStateChanged.map<ReduxAction>((firebaseUser) {
      if (firebaseUser == null) {
        return ClearUserData();
      }
      return StoreUser((b) => b..user.replace(firebaseUser.toUser()));
    });
  }

  Stream<ReduxAction> get googleSignInStream async* {
    // signal to change UI
    yield StoreAuthStep((b) => b..step = AuthStep.signingInWithGoogle);

    try {
      final googleUser = await _googleSignIn.signIn();

      // if the user canceled signin, an error is thrown but it gets swallowed
      // by the signIn() method so we need to reset the UI and close the stream
      if (googleUser == null) {
        yield StoreAuthStep((b) => b..step = AuthStep.waitingForInput);
        return;
      }

      // signal to change UI
      yield StoreAuthStep((b) => b..step = AuthStep.signingInWithFirebase);

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      /// the auth info will be picked up by the listener on [onAuthStateChanged]
      /// and emitted by [streamOfStateChanges]
      await _fireAuth.signInWithCredential(credential);

      // we are signed in so reset the UI and pop anything on top of home
      yield StoreAuthStep((b) => b..step = AuthStep.waitingForInput);
      yield NavigatorPopAll();
    } catch (error, trace) {
      // reset the UI and display an alert

      yield StoreAuthStep((b) => b..step = AuthStep.waitingForInput);
      // errors with code kSignInCanceledError are swallowed by the
      // GoogleSignIn.signIn() method so we can assume anything caught here
      // is a problem and send to the store for display
      yield AddProblem.from(
        message: error.toString(),
        type: ProblemType.googleSignIn,
        traceString: trace.toString(),
      );
    }
  }

  Stream<ReduxAction> get appleSignInStream async* {
    // signal to change UI
    yield StoreAuthStep((b) => b..step = AuthStep.signingInWithApple);

    try {
      // get an AuthorizationCredentialAppleID
      final appleIdCredential = await _appleSignIn.getAppleIDCredential();

      // signal to change UI
      yield StoreAuthStep((b) => b..step = AuthStep.signingInWithFirebase);

      // get an OAuthCredential
      final credential = OAuthProvider(providerId: 'apple.com').getCredential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );

      // use the credential to sign in to firebase
      await FirebaseAuth.instance.signInWithCredential(credential);

      // we are signed in so reset the UI and pop anything on top of home
      yield StoreAuthStep((b) => b..step = AuthStep.waitingForInput);
      yield NavigatorPopAll();
    } on SignInWithAppleAuthorizationException catch (e) {
      // reset the UI and display an alert (if not canceled)
      yield StoreAuthStep((b) => b..step = AuthStep.waitingForInput);
      switch (e.code) {
        case AuthorizationErrorCode.canceled:
          break;
        default:
          yield AddProblem.from(
              message: e.toString(),
              type: ProblemType.appleSignIn,
              info: BuiltMap({'code': e.code}));
      }
    } catch (error, trace) {
      // reset the UI and display an alert

      yield StoreAuthStep((b) => b..step = AuthStep.waitingForInput);
      // any specific errors are caught and dealt with so we can assume
      // anything caught here is a problem and send to the store for display
      yield AddProblem.from(
        message: error.toString(),
        type: ProblemType.appleSignIn,
        traceString: trace.toString(),
      );
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
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // successful sign in will update the onAuthStateChanged stream
      // but we should navigate back to home
      return NavigatorPopAll();
    } catch (error, trace) {
      return AddProblem.from(
        message: error.toString(),
        type: ProblemType.emailSignIn,
        traceString: trace.toString(),
      );
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
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // successful sign up will update the onAuthStateChanged stream
      // but we should navigate back to home
      return NavigatorPopAll();
    } catch (error, trace) {
      return AddProblem.from(
        message: error.toString(),
        type: ProblemType.emailSignUp,
        traceString: trace.toString(),
      );
    }
  }

  Future<ReduxAction> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await _googleSignIn.signOut();
      // TODO: add sign out for sign in with apple provider
      // see Issue #6 https://github.com/nickmeinhold/crowdleague_public/issues/6
    } catch (error, trace) {
      return AddProblem.from(
        message: error.toString(),
        type: ProblemType.signOut,
        traceString: trace.toString(),
      );
    }

    // we let the AuthStateObserver dispatch a ClearUserData action when it
    // observes the relevant event
    return null;
  }
}
