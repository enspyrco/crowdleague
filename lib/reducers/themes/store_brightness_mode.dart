import 'package:crowdleague/actions/themes/store_brightness_mode.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class StoreBrightnessModeReducer
    extends TypedReducer<AppState, StoreBrightnessMode> {
  StoreBrightnessModeReducer()
      : super((state, action) =>
            state.rebuild((b) => b..settings.brightnessMode = action.mode));
}
