import 'package:crowdleague/actions/auth/sign_in_with_apple.dart';
import 'package:crowdleague/actions/navigation/navigator_pop_all.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/middleware/auth/sign_in_with_apple.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../mocks/redux_store_mocks.dart';
import '../../../mocks/services/auth_service_mocks.dart';

void main() {
  group('SignInWithAppleMiddleware', () {
    test('listen to authService.appleSignInStream', () async {
      // initialize test store/services
      final mockAuthService = MockAuthService();
      final testStore =
          DispatchVerifyingStore(null, initialState: AppState.init());

      // return redux action from appleSignInStream
      // when(mockAuthService.appleSignInStream)
      //     .thenAnswer((_) => Stream.fromIterable([ReduxAction()]));

      // setup middleware
      await SignInWithAppleMiddleware(mockAuthService)(
          testStore, SignInWithApple(), (dynamic x) => x);

      // check that middleware is listening to stream
      verify(mockAuthService.appleSignInStream.listen).called(1);
    });
  });
}
