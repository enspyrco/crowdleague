import 'package:crowdleague/models/actions/leaguers/store_leaguers.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app/app_state.dart';

/// Reducers specify how the application"s state changes in response to actions
/// sent to the store.
///
/// Each reducer returns a new [AppState].
final leaguersReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, StoreLeaguers>(_storeLeaguers),
];

AppState _storeLeaguers(AppState state, StoreLeaguers action) {
  return state.rebuild((b) =>
      b..newConversationsPage.leaguersVM.leaguers.replace(action.leaguers));
}
