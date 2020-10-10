import 'package:crowdleague/actions/auth/sign_in_with_email.dart';
import 'package:crowdleague/actions/device/check_platform.dart';
import 'package:crowdleague/actions/navigation/navigator_pop_all.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/middleware/auth/sign_in_with_email.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';

import '../../../mocks/auth/apple_signin_mocks.dart';
import '../../../mocks/auth/firebase_auth_mocks.dart';
import '../../../mocks/auth/google_signin_mocks.dart';
import '../../../mocks/redux_store_mocks.dart';
import '../../../mocks/services/auth_service_mocks.dart';
import '../../../utils/verify_dispatch_middleware.dart';

void main() {
  group('SignInWithEmailMiddleware', () {
    test('sets OtherAuthOptionsPage UI to waiting', () async {
      // init fakes
      final fakeFirebaseAuth = FakeFirebaseAuth1();
      final fakeGoogleSignIn = FakeGoogleSignIn();
      final fakeAppleSignIn = FakeAppleSignIn();
      final authService =
          AuthService(fakeFirebaseAuth, fakeGoogleSignIn, fakeAppleSignIn);

      // create a basic store with mocked out middleware
      final store = Store<AppState>(appReducer,
          initialState: AppState.init(),
          middleware: [SignInWithEmailMiddleware(authService)]);

      // initial state
      expect(store.state.emailAuthOptionsPage.step, AuthStep.waitingForInput);

      // dispatch action to test middleware
      store.dispatch(SignInWithEmail());

      // check store is correctly updated
      expect(
          store.state.emailAuthOptionsPage.step, AuthStep.signingInWithEmail);
    });

    test('on successfull sign in, dispatches Navigator.popAll action',
        () async {
      // init fakes
      final fakeAuthService = FakeAuthService();
      final fakeStore = FakeStore();

      // setup middleware
      SignInWithEmailMiddleware(fakeAuthService)(
          fakeStore, SignInWithEmail(), (dynamic x) => x);

      verify(fakeAuthService.signInWithEmail(any, any));

      // // initial state
      // expect(store.state.problems.isEmpty, true);

      // // dispatch action to test middleware
      // store.dispatch(SignInWithEmail());

      // // check that we are setting ui to loading indicator
      // expect(
      //     testMiddleware.received(
      //         UpdateOtherAuthOptionsPage(step: AuthStep.signingInWithEmail)),
      //     true);
      // expect(testMiddleware.received(NavigatorPopAll()), true);
    });

    test('on error signing in with firebase, dispatch addPropblem action',
        () async {
      // init fakes
      final fakeFirebaseAuth = FakeFirebaseAuthWithError();
      final fakeGoogleSignIn = FakeGoogleSignIn();
      final fakeAppleSignIn = FakeAppleSignIn();
      final authService =
          AuthService(fakeFirebaseAuth, fakeGoogleSignIn, fakeAppleSignIn);

      // create a basic store with mocked out middleware
      final store = Store<AppState>(appReducer,
          initialState: AppState.init(),
          middleware: [SignInWithEmailMiddleware(authService)]);

      // initial state
      expect(store.state.problems.isEmpty, true);

      // dispatch action to test middleware
      store.dispatch(SignInWithEmail());

      // check store is correctly updated
      expect(store.state.problems[0].type, ProblemType.emailSignIn);
    });
  });
}
