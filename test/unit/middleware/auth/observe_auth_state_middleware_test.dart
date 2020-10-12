import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/actions/auth/clear_user_data.dart';
import 'package:crowdleague/actions/auth/observe_auth_state.dart';
import 'package:crowdleague/actions/auth/store_user.dart';
import 'package:crowdleague/middleware/auth/observe_auth_state.dart';
import 'package:crowdleague/models/auth/user.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../mocks/redux/redux_store_mocks.dart';
import '../../../mocks/services/auth_service_mocks.dart';
import '../../util/testing_utils.dart';

void main() {
  group('ObserveAuthStateMiddleware', () {
    test('when user signs in, then signs out. Dispatch correct actions ',
        () async {
      // initialize test store/services
      final mockAuthService = MockAuthService();
      final testStore = DispatchVerifyingStore();
      final testUser = User(
        id: 'test123',
        displayName: 'test_user',
        photoURL: 'i-like-tests',
        email: 'test@email.com',
        providers: BuiltList(),
      );

      // sign user in, then sign user out
      when(mockAuthService.streamOfStateChanges).thenAnswer((_) =>
          Stream.fromIterable([StoreUser(user: testUser), ClearUserData()]));

      // setup middleware
      await ObserveAuthStateMiddleware(mockAuthService)(
          testStore, ObserveAuthState(), testDispatcher);

      // check that correct actions are called in desired order
      verifyInOrder<dynamic>(<dynamic>[
        testStore.dispatch(StoreUser(user: testUser)),
        testStore.dispatch(ClearUserData()),
      ]);
    });
  });
}
