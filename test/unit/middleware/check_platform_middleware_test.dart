import 'package:crowdleague/actions/device/check_platform.dart';
import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:crowdleague/middleware/device/check_platform.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';

import '../../mocks/services/device_service_mocks.dart';

void main() {
  group('CheckPlatformMiddleware', () {
    test('gets platform value and dispatches store action', () async {
      final fakeService = FakeDeviceService();

      // create a basic store with mocked out middleware
      final store = Store<AppState>(appReducer,
          initialState: AppState.init(),
          middleware: [CheckPlatformMiddleware(fakeService)]);

      // initial state
      expect(store.state.systemInfo.platform, PlatformType.checking);

      // dispatch action to test middleware
      store.dispatch(CheckPlatform());

      // check store is correctly updated
      expect(store.state.systemInfo.platform, PlatformType.macOS);
    });
  });
}
