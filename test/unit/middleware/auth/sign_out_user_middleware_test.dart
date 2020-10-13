import 'package:crowdleague/actions/auth/sign_out_user.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/middleware/auth/sign_out_user.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../mocks/redux/redux_store_mocks.dart';
import '../../../mocks/services/auth_service_mocks.dart';
import '../../util/testing_utils.dart';

void main() {
  group('SignOutUserMiddleware', () {
    test('on error signing out, dispatches correct actions', () async {
      // initialize test store/services
      final mockAuthService = MockAuthService();
      final testStore = DispatchVerifyingStore();
      final problem = AddProblem.from(
        message: '',
        type: ProblemType.signOut,
        traceString: '',
      );

      // return error signing out user
      when(mockAuthService.signOut()).thenAnswer((_) async => problem);

      // setup middleware
      final mut = SignOutUserMiddleware(mockAuthService);
      await mut(testStore, SignOutUser(), testDispatcher);

      // check that correct actions are called in desired order
      verifyInOrder<dynamic>(<dynamic>[
        testStore.dispatch(problem),
      ]);
    });
    test('on successful sign out, does not dispatch any actions', () async {
      // initialize test store/services
      final mockAuthService = MockAuthService();
      final testStore = DispatchVerifyingStore();

      // return error signing out user
      when(mockAuthService.signOut()).thenAnswer((_) async => null);

      // setup middleware
      final mut = SignOutUserMiddleware(mockAuthService);
      await mut(testStore, SignOutUser(), testDispatcher);

      // check that no actions were dispatched
      expect(testStore.dispatchedActions.length, 0);
    });
  });
}
