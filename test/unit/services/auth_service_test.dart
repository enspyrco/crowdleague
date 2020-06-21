import 'package:crowdleague/actions/problems/add_problem.dart';
import 'package:crowdleague/actions/auth/store_auth_step.dart';
import 'package:crowdleague/actions/auth/store_user.dart';
import 'package:crowdleague/actions/navigation/navigator_pop_all.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:test/test.dart';

import '../../mocks/auth/apple_signin_mocks.dart';
import '../../mocks/auth/firebase_auth_mocks.dart';
import '../../mocks/auth/google_signin_mocks.dart';

// TODO: test that sign streams close when sign in has finished
// TODO: test that sign streams close when sign in errors
// TODO: test sign out - dispatches a StoreProblem action on error

void main() {
  group('Auth Service', () {
    // has a method that returns a stream that emits user

    test('provides a stream of user objects', () {
      final service =
          AuthService(FakeFirebaseAuth1(), FakeGoogleSignIn(), null);

      service.streamOfStateChanges.listen(expectAsync1((action) {
        expect(action is StoreUser, true);
      }, count: 1));
    });

    test('googleSignInStream resets auth steps on cancel', () {
      final service =
          AuthService(FakeFirebaseAuth1(), FakeGoogleSignInCancels(), null);

      // the service should set auth step to signing in with google
      // then due to user cancel (which means google sign in returns null)
      // the service should reset the auth step to waiting for input
      final expectedAuthSteps = [
        AuthStep.signingInWithGoogle,
        AuthStep.waitingForInput
      ];

      service.googleSignInStream.listen(expectAsync1((action) {
        expect((action as StoreAuthStep).step, expectedAuthSteps.removeAt(0));
      }, count: 2));
    });

    /// Setup an [AuthService] with mocks so the googleSignInStream
    /// emits the same sequence of [ReduxAction]s as a normal sign in
    test('googleSignInStream emits StoreAuthStep actions at each stage', () {
      final service =
          AuthService(FakeFirebaseAuth1(), FakeGoogleSignIn(), null);

      expect(
          service.googleSignInStream,
          emitsInOrder(<ReduxAction>[
            StoreAuthStep((b) => b..step = AuthStep.signingInWithGoogle),
            StoreAuthStep((b) => b..step = AuthStep.signingInWithFirebase),
            StoreAuthStep((b) => b..step = AuthStep.waitingForInput),
            NavigatorPopAll()
          ]));
    });

    test('googleSignInStream catches errors and emits StoreProblem actions',
        () async {
      final service =
          AuthService(FakeFirebaseAuth1(), FakeGoogleSignInThrows(), null);

      /// The service will emit the google sign in step then the google signin
      /// object throws and the service catches the exception then emits
      /// an action to reset the auth step then emits a problem with
      /// info about the exception.
      ///
      /// We use a [TypeMatcher] as it's difficult to create the expected
      /// [Problem] due to the [Problem.trace] member
      expect(
          service.googleSignInStream,
          emitsInOrder(<dynamic>[
            StoreAuthStep((b) => b..step = AuthStep.signingInWithGoogle),
            StoreAuthStep((b) => b..step = AuthStep.waitingForInput),
            TypeMatcher<AddProblem>()
              ..having((p) => p.problem.type, 'type', ProblemType.googleSignIn)
              ..having((p) => p.problem.message, 'message',
                  equals('Exception: GoogleSignIn.signIn')),
          ]));
    });

    test('appleSignInStream resets auth steps on cancel', () {
      final service =
          AuthService(FakeFirebaseAuth1(), null, FakeAppleSignInCancels());

      /// The service should set auth step to signingInWithApple
      /// then due to user cancel the service should reset the UI.
      expect(
          service.appleSignInStream,
          emitsInOrder(<dynamic>[
            StoreAuthStep((b) => b..step = AuthStep.signingInWithApple),
            StoreAuthStep((b) => b..step = AuthStep.waitingForInput),
          ]));
    });

    test('appleSignInStream emits StoreAuthStep actions at each stage', () {
      final service = AuthService(FakeFirebaseAuth1(), null, FakeAppleSignIn());

      /// The service will emit [StoreAuthStep] with [AuthStep.signingInWithApple]
      /// then another [StoreAuthStep], with [AuthStep.signingInWithFirebase].
      /// The apple signin object then throws, the service catches the exception
      /// and (in order to reset the UI) emits [StoreAuthStep] with
      /// [AuthStep.waitingForInput]. Finally the service emits [AddProblem]
      /// with a problem that has info about the exception.
      ///
      /// We use a [TypeMatcher] as it's difficult to create the expected
      /// [Problem] due to the [Problem.trace] member
      expect(
          service.appleSignInStream,
          emitsInOrder(<dynamic>[
            StoreAuthStep((b) => b..step = AuthStep.signingInWithApple),
            StoreAuthStep((b) => b..step = AuthStep.signingInWithFirebase),
            StoreAuthStep((b) => b..step = AuthStep.waitingForInput),
            TypeMatcher<AddProblem>()
              ..having((p) => p.problem.type, 'type', ProblemType.appleSignIn)
              ..having((p) => p.problem.message, 'message',
                  equals('Exception: AppleSignIn.signIn')),
          ]));
    });

    // test that errors are handled by being passed to the store
    test('appleSignInStream catches errors and emits StoreProblem actions',
        () async {
      final service =
          AuthService(FakeFirebaseAuth1(), null, FakeAppleSignInThrows());

      // the service will emit step 1 indicating apple signin is occuring
      // the apple signin throws and the service catches the exception then
      // emits an action to reset the auth step then emits a problem with info
      // about the exception
      expect(
          service.googleSignInStream,
          emitsInOrder(<dynamic>[
            TypeMatcher<StoreAuthStep>()..having((a) => a.step, 'step', 1),
            TypeMatcher<StoreAuthStep>()..having((a) => a.step, 'step', 0),
            TypeMatcher<AddProblem>()
              ..having((p) => p.problem.type, 'type', ProblemType.appleSignIn)
              ..having((p) => p.problem.message, 'message',
                  equals('Exception: AppleSignIn.signIn')),
            emitsDone,
          ]));
    });
  });
}
