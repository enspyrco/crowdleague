import 'package:crowdleague/actions/auth/sign_in_with_email.dart';
import 'package:crowdleague/actions/auth/update_email_auth_options_page.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/actions/navigation/navigator_pop_all.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/middleware/auth/sign_in_with_email.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../mocks/redux/redux_store_mocks.dart';
import '../../../mocks/services/auth_service_mocks.dart';
import '../../util/testing_utils.dart';

void main() {
  group('SignInWithEmailMiddleware', () {
    test('on successfull sign with firebase, dispatches correct actions',
        () async {
      // initialize test store/services
      final mockAuthService = MockAuthService();
      final testStore = DispatchVerifyingStore();

      // sign user in successfully
      when(mockAuthService.signInWithEmail(any, any))
          .thenAnswer((_) async => NavigatorPopAll());

      // setup middleware
      await SignInWithEmailMiddleware(mockAuthService)(
          testStore, SignInWithEmail(), testDispatcher);

      // check that correct actions are called in desired order
      verifyInOrder<dynamic>(<dynamic>[
        testStore.dispatch(
            UpdateEmailAuthOptionsPage(step: AuthStep.signingInWithEmail)),
        testStore.dispatch(NavigatorPopAll()),
        testStore.dispatch(
            UpdateEmailAuthOptionsPage(step: AuthStep.waitingForInput))
      ]);
    });

    test('on error signing in with firebase, dispatches correct actions',
        () async {
      // initialize test store/services
      final mockAuthService = MockAuthService();
      final testStore = DispatchVerifyingStore();
      final problem = AddProblem.from(
        message: '',
        type: ProblemType.emailSignIn,
        traceString: '',
      );

      // create firebase sign in error
      when(mockAuthService.signInWithEmail(any, any))
          .thenAnswer((_) async => problem);

      // setup middleware
      await SignInWithEmailMiddleware(mockAuthService)(
          testStore, SignInWithEmail(), testDispatcher);

      // check that correct actions are called in desired order
      verifyInOrder<dynamic>(<dynamic>[
        testStore.dispatch(
            UpdateEmailAuthOptionsPage(step: AuthStep.signingInWithEmail)),
        testStore.dispatch(problem),
        testStore.dispatch(
            UpdateEmailAuthOptionsPage(step: AuthStep.waitingForInput))
      ]);
    });
  });
}
