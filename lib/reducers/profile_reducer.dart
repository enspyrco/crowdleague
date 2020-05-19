import 'package:crowdleague/actions/profile/store_profile_leaguer.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

final profileReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, StoreProfileLeaguer>(_storeProfileLeaguer),
];

AppState _storeProfileLeaguer(AppState state, StoreProfileLeaguer action) {
  return state.rebuild((b) => b..profilePage.leaguer.replace(action.leaguer));
}
