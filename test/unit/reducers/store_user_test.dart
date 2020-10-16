import 'package:crowdleague/actions/auth/clear_user_data.dart';
import 'package:crowdleague/actions/device/store_platform.dart';
import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';

void main() {
  group('StoreUserReducer', () {
    test('clears any user data from state', () {
      // create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // dispatch action to clear user data
      store.dispatch(ClearUserData());

      // check that the store has the expected value
      // expect(store.state.systemInfo.platform, PlatformType.macOS);

      //
    });
  });
}
