import 'package:crowdleague/actions/device/store_platform.dart';
import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';

void main() {
  group('StorePlatformReducer', () {
    test('updates platform value', () {
      // create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // dispatch action to add a problem
      store.dispatch(StorePlatform(value: PlatformType.macOS));

      // check that the store has the expected value
      expect(store.state.systemInfo.platform, PlatformType.macOS);
    });
  });
}
