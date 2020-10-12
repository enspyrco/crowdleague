import 'package:crowdleague/actions/auth/sign_in_with_apple.dart';
import 'package:crowdleague/middleware/auth/sign_in_with_apple.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../mocks/redux_store_mocks.dart';
import '../../../mocks/services/auth_service_mocks.dart';
import '../../util/util_testing_functions.dart';

void main() {
  group('SignInWithAppleMiddleware', () {
    test('listen to authService.appleSignInStream', () async {
      // initialize test store/services
      final mockAuthService = MockAuthService();
      final testStore = DispatchVerifyingStore();

      // return redux action from appleSignInStream
      when(mockAuthService.appleSignInStream)
          .thenAnswer((_) => Stream.fromIterable([]));

      // setup middleware
      final mut = SignInWithAppleMiddleware(mockAuthService);

      mut(testStore, SignInWithApple(), iDispatcher);

      // check that middleware is listening to stream
      verify(mockAuthService.appleSignInStream).called(1);
    });
  });
}
