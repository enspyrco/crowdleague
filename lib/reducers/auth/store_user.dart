import 'package:crowdleague/actions/auth/store_user.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

/// Set the user object to null if action has null user or update the state
/// with the new user
class StoreUserReducer extends TypedReducer<AppState, StoreUser> {
  StoreUserReducer()
      : super((state, action) =>
            state.rebuild((b) => b..user = action.user?.toBuilder()));
}
