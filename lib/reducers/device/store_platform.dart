import 'package:crowdleague/actions/device/store_platform.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class StorePlatformReducer extends TypedReducer<AppState, StorePlatform> {
  StorePlatformReducer()
      : super((state, action) =>
            state.rebuild((b) => b..platform = action.value));
}
