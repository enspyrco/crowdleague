import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:crowdleague/services/device_service.dart';

import 'package:mockito/mockito.dart';

class MockDeviceService extends Mock implements DeviceService {}

class FakeDeviceService extends Fake implements DeviceService {
  @override
  Future<String> pickProfilePic() {
    return Future.value('pickProfilePic');
  }

  @override
  PlatformType get platformType => PlatformType.macOS;
}
