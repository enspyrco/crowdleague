import 'package:crowdleague/models/actions/add_problem.dart';
import 'package:crowdleague/models/actions/clear_user_data.dart';
import 'package:crowdleague/models/actions/set_email_auth_mode.dart';
import 'package:crowdleague/models/actions/set_password_visibility.dart';
import 'package:crowdleague/models/actions/store_auth_step.dart';
import 'package:crowdleague/models/actions/store_nav_index.dart';
import 'package:crowdleague/models/actions/store_user.dart';
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
  TypedReducer<AppState, SetEmailAuthMode>(_storeEmailAuthMode),
  TypedReducer<AppState, SetPasswordVisibility>(_storePasswordVisibility),

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

AppState _storeEmailAuthMode(AppState state, SetEmailAuthMode action) {
  return state.rebuild((b) => b..otherAuthOptions.mode = action.mode);
}

AppState _storePasswordVisibility(
    AppState state, SetPasswordVisibility action) {
  return state
      .rebuild((b) => b..otherAuthOptions.passwordVisible = action.visible);
}
