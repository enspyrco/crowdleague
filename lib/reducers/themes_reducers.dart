import 'package:crowdleague/actions/themes/store_brightness_mode.dart';
import 'package:crowdleague/actions/themes/store_theme_colors.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

final themesReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, StoreBrightnessMode>(_storeBrightnessMode),
  TypedReducer<AppState, StoreThemeColors>(_storeThemeColors),
];

AppState _storeBrightnessMode(AppState state, StoreBrightnessMode action) {
  return state.rebuild((b) => b..settings.brightnessMode = action.mode);
}

AppState _storeThemeColors(AppState state, StoreThemeColors action) {
  return state.rebuild((b) => b
    ..settings.darkTheme.colors.replace(action.colors)
    ..settings.lightTheme.colors.replace(action.colors));
}
