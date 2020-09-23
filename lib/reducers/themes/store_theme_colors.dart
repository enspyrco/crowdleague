import 'package:crowdleague/actions/themes/store_theme_colors.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class StoreThemeColorsReducer extends TypedReducer<AppState, StoreThemeColors> {
  StoreThemeColorsReducer()
      : super((state, action) => state.rebuild((b) => b
          ..settings.darkTheme.colors.replace(action.colors)
          ..settings.lightTheme.colors.replace(action.colors)));
}
