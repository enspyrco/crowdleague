import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/auth/clear_user_data_reducer.dart';
import 'package:crowdleague/reducers/auth/store_auth_step_reducer.dart';
import 'package:crowdleague/reducers/auth/store_user_reducer.dart';
import 'package:crowdleague/reducers/auth/update_other_auth_options_page_reducer.dart';
import 'package:crowdleague/reducers/leaguers_reducers.dart';
import 'package:crowdleague/reducers/navigation_reducers.dart';
import 'package:crowdleague/reducers/profile_reducers.dart';
import 'package:crowdleague/reducers/storage_reducers.dart';
import 'package:crowdleague/reducers/themes_reducers.dart';
import 'package:redux/redux.dart';

/// Reducers specify how the application's state changes in response to actions
/// sent to the store. Each reducer returns a new [AppState].
///
/// Reducers are
final appReducer =
    combineReducers<AppState>(<AppState Function(AppState, dynamic)>[
  // Auth
  ClearUserDataReducer(),
  StoreAuthStepReducer(),
  StoreUserReducer(),
  UpdateOtherAuthOptionsPageReducer(),
  // Conversations

  ...leaguersReducers,
  ...conversationsReducers,
  ...navigationReducers,
  ...themesReducers,
  ...profileReducers,
  ...storageReducers,
]);
