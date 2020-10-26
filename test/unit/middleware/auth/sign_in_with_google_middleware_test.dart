import 'package:crowdleague/actions/auth/sign_in_with_google.dart';
import 'package:crowdleague/middleware/auth/sign_in_with_google.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../mocks/redux/redux_action_mocks.dart';
import '../../../mocks/redux/redux_store_mocks.dart';
import '../../../mocks/services/auth_service_mocks.dart';
import '../../util/testing_utils.dart';

void main() {
  group('SignInWithGoogleMiddleware', () {
    test('dispatches actions emitted by authService.googleSignInStream', () {
      // initialize test store/services
      final mockAuthService = MockAuthService();
      final testStore = FakeStore();
      final testAction = MockReduxAction();

      // return a stream that emits 2 redux actions from googleSignInStream
      when(mockAuthService.googleSignInStream)
          .thenAnswer((_) => Stream.fromIterable([testAction]));

      // setup middleware and invoke the middleware
      final mut = SignInWithGoogleMiddleware(mockAuthService);
      mut(testStore, SignInWithGoogle(), testDispatcher);

      // check that the service's stream emits the expected actions and the store
      // dispatched the same action
      mockAuthService.googleSignInStream.listen(expectAsync1((action) {
        expect(action, equals(testAction));
        expect(testStore.dispatchedActions.contains(testAction), true);
      }, count: 1));
    });
  });
}
