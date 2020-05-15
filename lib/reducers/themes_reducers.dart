import 'package:crowdleague/actions/themes/store_brightness_mode.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

final themesReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, StoreBrightnessMode>(_storeBrightnessMode),
];

AppState _storeBrightnessMode(AppState state, StoreBrightnessMode action) {
  return state.rebuild((b) => b..themeValues.brightnessMode = action.mode);
}
