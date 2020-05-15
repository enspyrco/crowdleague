import 'package:crowdleague/reducers/auth_reducers.dart';
import 'package:crowdleague/reducers/conversations_reducers.dart';
import 'package:crowdleague/reducers/leaguers_reducers.dart';
import 'package:crowdleague/reducers/navigation_reducers.dart';
import 'package:crowdleague/reducers/themes_reducers.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app/app_state.dart';

/// Reducers specify how the application"s state changes in response to actions
/// sent to the store.
///
/// Each reducer returns a new [AppState].
final appReducer =
    combineReducers<AppState>(<AppState Function(AppState, dynamic)>[
  ...authReducers,
  ...leaguersReducers,
  ...conversationsReducers,
  ...navigationReducers,
  ...themesReducers,
]);
