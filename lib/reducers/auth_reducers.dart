import 'package:crowdleague/actions/auth/clear_user_data.dart';
import 'package:crowdleague/actions/auth/store_auth_step.dart';
import 'package:crowdleague/actions/auth/store_user.dart';
import 'package:crowdleague/actions/auth/update_other_auth_options_page.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

/// Reducers specify how the application"s state changes in response to actions
/// sent to the store.
///
/// Each reducer returns a new [AppState].
final authReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, ClearUserData>(_clearUserData),
  TypedReducer<AppState, StoreUser>(_storeUser),
  TypedReducer<AppState, StoreAuthStep>(_storeAuthStep),
  TypedReducer<AppState, UpdateOtherAuthOptionsPage>(_updateOtherAuthOptions),
];

// return to the initial state, clearing all of the user's data
AppState _clearUserData(AppState state, ClearUserData action) =>
    AppState.init();

/// Set the user object to null if action has null user or update the state
/// with the new user
AppState _storeUser(AppState state, StoreUser action) {
  return state.rebuild((b) => b..user = action.user?.toBuilder());
}

AppState _storeAuthStep(AppState state, StoreAuthStep action) {
  return state.rebuild((b) => b
    ..authPage.step = action.step
    ..otherAuthOptionsPage.step = action.step);
}

/// A single reducer for all OtherAuthOptionsViewModel members is less
/// efficient but requires less code (actions and reducers)
/// [UpdateOtherAuthOptions] contains values to be updated or null
AppState _updateOtherAuthOptions(
    AppState state, UpdateOtherAuthOptionsPage action) {
  return state.rebuild((a) {
    a.otherAuthOptionsPage.mode = action.mode ?? a.otherAuthOptionsPage.mode;
    a.otherAuthOptionsPage.showPassword =
        action.showPassword ?? a.otherAuthOptionsPage.showPassword;
    a.otherAuthOptionsPage.step = action.step ?? a.otherAuthOptionsPage.step;
    a.otherAuthOptionsPage.email = action.email ?? a.otherAuthOptionsPage.email;
    a.otherAuthOptionsPage.password =
        action.password ?? a.otherAuthOptionsPage.password;
    a.otherAuthOptionsPage.repeatPassword =
        action.repeatPassword ?? a.otherAuthOptionsPage.repeatPassword;
  });
}
