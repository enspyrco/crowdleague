import 'package:crowdleague/actions/auth/clear_user_data.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

/// Return to the initial state, clearing all of the user's data
class ClearUserDataReducer extends TypedReducer<AppState, ClearUserData> {
  ClearUserDataReducer()
      : super((state, action) => AppState.init()
            .rebuild((b) => b..systemInfo.replace(state.systemInfo)));
}
