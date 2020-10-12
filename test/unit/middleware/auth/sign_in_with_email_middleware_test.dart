import 'package:crowdleague/actions/auth/sign_in_with_email.dart';
import 'package:crowdleague/actions/auth/update_email_auth_options_page.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/actions/navigation/navigator_pop_all.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/middleware/auth/sign_in_with_email.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../mocks/redux_store_mocks.dart';
import '../../../mocks/services/auth_service_mocks.dart';

void main() {
  group('SignInWithEmailMiddleware', () {
    test('on successfull sign with firebase, dispatches correct actions',
        () async {
      // init fakes
      final mockAuthService = MockAuthService();
      final stubStore = StubStore(null, initialState: AppState.init());
      when(mockAuthService.signInWithEmail(any, any))
          .thenAnswer((_) async => NavigatorPopAll());

      // setup middleware
      await SignInWithEmailMiddleware(mockAuthService)(
          stubStore, SignInWithEmail(), (dynamic x) => x);

      // check that correct actions are called
      final actionsInOrderOfCall = <ReduxAction>[
        UpdateEmailAuthOptionsPage(step: AuthStep.signingInWithEmail),
        NavigatorPopAll(),
        UpdateEmailAuthOptionsPage(step: AuthStep.waitingForInput)
      ];
      expect(stubStore.dispatchedActions, actionsInOrderOfCall);
    });

    test('on error signing in with firebase, dispatches correct actions',
        () async {
      // init fakes
      final mockAuthService = MockAuthService();
      final stubStore = StubStore(null, initialState: AppState.init());
      final problem = AddProblem.from(
        message: '',
        type: ProblemType.emailSignIn,
        traceString: '',
      );
      when(mockAuthService.signInWithEmail(any, any))
          .thenAnswer((_) async => problem);

      // setup middleware
      await SignInWithEmailMiddleware(mockAuthService)(
          stubStore, SignInWithEmail(), (dynamic x) => x);

      // check that correct actions are called
      final actionsInOrderOfCall = <ReduxAction>[
        UpdateEmailAuthOptionsPage(step: AuthStep.signingInWithEmail),
        problem,
        UpdateEmailAuthOptionsPage(step: AuthStep.waitingForInput)
      ];
      expect(stubStore.dispatchedActions, actionsInOrderOfCall);
    });
  });
}
