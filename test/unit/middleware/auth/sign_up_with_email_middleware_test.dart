import 'package:crowdleague/actions/auth/sign_up_with_email.dart';
import 'package:crowdleague/middleware/auth/sign_up_with_email.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../mocks/redux/redux_action_mocks.dart';
import '../../../mocks/redux/redux_store_mocks.dart';
import '../../../mocks/services/auth_service_mocks.dart';
import '../../util/testing_utils.dart';

void main() {
  group('SignUpWithEmailMiddleware', () {
    test('dispatches actions emitted by authService.emailSignUpStream', () {
      // initialize test services
      final mockAuthService = MockAuthService();

      // build state with email and password
      final testEmail = 'test@email.com';
      final testPassword = 'test_password';
      final testAppState = AppState.init().rebuild((b) => b
        ..emailAuthOptionsPage.email = testEmail
        ..emailAuthOptionsPage.password = testPassword);

      // build test store
      final testStore = DispatchVerifyingStore(initialState: testAppState);
      final testAction = MockReduxAction();

      // return a stream that emits a redux action from emailSignUpStream
      when(mockAuthService.emailSignUpStream(testEmail, testPassword))
          .thenAnswer((_) => Stream.fromIterable([testAction]));

      // setup middleware and invoke the middleware
      final mut = SignUpWithEmailMiddleware(mockAuthService);
      mut(testStore, SignUpWithEmail(), testDispatcher);

      // check that the service's stream emits the expected action and the store
      // dispatched the same action
      mockAuthService
          .emailSignUpStream(testEmail, testPassword)
          .listen(expectAsync1((action) {
            expect(action, equals(testAction));
            expect(testStore.dispatchedActions.contains(testAction), true);
          }, count: 1));
    });
  });
}