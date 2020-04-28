import 'package:crowdleague/models/actions/add_problem.dart';
import 'package:crowdleague/models/actions/auth/clear_user_data.dart';
import 'package:crowdleague/models/actions/auth/store_auth_step.dart';
import 'package:crowdleague/models/actions/auth/store_user.dart';
import 'package:crowdleague/models/actions/auth/update_other_auth_options.dart';
import 'package:crowdleague/models/actions/store_nav_index.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app_state.dart';

/// Reducers specify how the application"s state changes in response to actions
/// sent to the store.
///
/// Each reducer returns a new [AppState].
final appReducer = combineReducers<AppState>([
  TypedReducer<AppState, AddProblem>(_addProblem),
  TypedReducer<AppState, ClearUserData>(_clearUserData),
  TypedReducer<AppState, StoreUser>(_storeUser),
  TypedReducer<AppState, StoreAuthStep>(_storeAuthStep),
  TypedReducer<AppState, StoreNavIndex>(_storeNavIndex),
  TypedReducer<AppState, UpdateOtherAuthOptions>(_updateOtherAuthOptions),

  // ...userReducers,
]);

AppState _addProblem(AppState state, AddProblem action) {
  return state.rebuild((b) => b..problems.add(action.problem));
}

// return to the initial state, clearing all of the user's data
AppState _clearUserData(AppState state, ClearUserData action) =>
    AppState.init();

AppState _storeUser(AppState state, StoreUser action) {
  // we need to be able to set user to null for when no user signed in
  // but replace won't take null
  // TODO: determine if there is a more elegant way to do this
  // see: https://github.com/google/built_value.dart/issues/238
  return (action.user == null)
      ? state.rebuild((b) => b..user = null)
      : state.rebuild((b) => b..user.replace(action.user));
}

AppState _storeAuthStep(AppState state, StoreAuthStep action) {
  return state.rebuild((b) => b..authStep = action.step);
}

AppState _storeNavIndex(AppState state, StoreNavIndex action) {
  return state.rebuild((b) => b..navIndex = action.index);
}

/// A single reducer for all OtherAuthOptionsViewModel members is less
/// efficient but requires less code (actions and reducers)
/// [UpdateOtherAuthOptions] contains values to be updated or null
///
/// TODO: I feel like there is a nicer way way to do this but have thought about
/// it a lot and can't think of anything -> seek advice from others
AppState _updateOtherAuthOptions(
    AppState state, UpdateOtherAuthOptions action) {
  return state.rebuild((a) {
    a.otherAuthOptions.mode = action.mode ?? a.otherAuthOptions.mode;
    a.otherAuthOptions.showPassword =
        action.showPassword ?? a.otherAuthOptions.showPassword;
    a.otherAuthOptions.step = action.step ?? a.otherAuthOptions.step;
    a.otherAuthOptions.email = action.email ?? a.otherAuthOptions.email;
    a.otherAuthOptions.password =
        action.password ?? a.otherAuthOptions.password;
    a.otherAuthOptions.repeatPassword =
        action.repeatPassword ?? a.otherAuthOptions.repeatPassword;
  });
}
