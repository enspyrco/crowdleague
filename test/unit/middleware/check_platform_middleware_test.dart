import 'package:crowdleague/actions/device/check_platform.dart';
import 'package:crowdleague/actions/device/store_platform.dart';
import 'package:crowdleague/middleware/device/check_platform.dart';
import 'package:test/test.dart';

import '../../mocks/redux/redux_store_mocks.dart';
import '../../mocks/services/device_service_mocks.dart';
import '../util/testing_utils.dart';

void main() {
  group('CheckPlatformMiddleware', () {
    test('gets platform value and dispatches store action', () async {
      // initialize mock services/store
      final fakeDeviceService = FakeDeviceService();
      final testStore = DispatchVerifyingStore();

      // setup middleware
      final mut = CheckPlatformMiddleware(fakeDeviceService);
      await mut(testStore, CheckPlatform(), testDispatcher);

      // check correct action is dispatched
      expect(testStore.dispatchedActions.length, 1);
      expect(testStore.dispatchedActions[0],
          StorePlatform(value: fakeDeviceService.platformType));
    });
  });
}
