import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:crowdleague/services/device_service.dart';
import 'package:test/test.dart';

import '../../mocks/wrappers/platform_wrapper_mocks.dart';

void main() {
  group('Device Service', () {
    test('checks and returns current device platform type', () {
      final fakePlatformWrapper = FakePlatformWrapper();
      final service = DeviceService(platform: fakePlatformWrapper);

      expect(service.platformType, PlatformType.macOS);
    });
  });
}
