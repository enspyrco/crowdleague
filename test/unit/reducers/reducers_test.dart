import 'package:crowdleague/actions/auth/clear_user_data.dart';
import 'package:crowdleague/actions/auth/store_auth_step.dart';
import 'package:crowdleague/actions/auth/store_user.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/enums/auth/auth_step.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:crowdleague/models/problems/sign_out_problem.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';

import '../../mocks/models/user_mocks.dart';

void main() {
  group('Reducer', () {
    test('_addProblem adds to the list', () {
      // create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // dispatch action to add a problem
      ProblemBase mockProblem = SignOutProblem.by((b) => b
        ..message = 'error'
        ..trace = 'trace');
      store.dispatch(
        AddProblem(problem: mockProblem),
      );

      // check that the store has the expected value
      expect(store.state.problems.length, 1);
      final problem = store.state.problems.first;
      expect(problem, mockProblem);
    });

    test('_clearUserData stores an empty user object', () {
      // create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // dispatch action to store a user object
      store.dispatch(StoreUser(user: mockUser));

      // check that the store has the expected value
      expect(store.state.user, mockUser);

      // dispatch action to store auth state
      store.dispatch(ClearUserData());

      // check that the store has the expected value
      expect(store.state, AppState.init());
    });

    test('_storeUser stores the given user object', () {
      // create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // dispatch action to store auth state
      store.dispatch(StoreUser(user: mockUser));

      // check that the store has the expected value
      expect(store.state.user, mockUser);
    });

    test('_storeAuthStep stores the auth step', () {
      // create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // dispatch action to store auth step
      store.dispatch(StoreAuthStep(step: AuthStep.signingInWithApple));

      // check that the store has the expected value
      expect(store.state.authPage.step, AuthStep.signingInWithApple);
    });
  });
}
