import 'package:crowdleague/actions/auth/sign_in_with_apple.dart';
import 'package:crowdleague/middleware/auth/sign_in_with_apple.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../mocks/redux/redux_action_mocks.dart';
import '../../../mocks/redux/redux_store_mocks.dart';
import '../../../mocks/services/auth_service_mocks.dart';
import '../../util/testing_utils.dart';

void main() {
  group('SignInWithAppleMiddleware', () {
    test('dispatches actions emitted by authService.appleSignInStream', () {
      // initialize test store/services
      final mockAuthService = MockAuthService();
      final testStore = FakeStore();
      final testAction = MockReduxAction();

      // return a stream that emits a redux action from appleSignInStream
      when(mockAuthService.appleSignInStream)
          .thenAnswer((_) => Stream.fromIterable([testAction]));

      // setup middleware and invoke the middleware
      final mut = SignInWithAppleMiddleware(mockAuthService);
      mut(testStore, SignInWithApple(), testDispatcher);

      // check that the service's stream emits the expected action and the store
      // dispatched the same action
      mockAuthService.appleSignInStream.listen(expectAsync1((action) {
        expect(action, equals(testAction));
        expect(testStore.dispatchedActions.contains(testAction), true);
      }, count: 1));
    });
  });
}
