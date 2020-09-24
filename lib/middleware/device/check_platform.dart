import 'package:crowdleague/actions/device/check_platform.dart';
import 'package:crowdleague/actions/device/store_platform.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/device_service.dart';
import 'package:redux/redux.dart';

class CheckPlatformMiddleware extends TypedMiddleware<AppState, CheckPlatform> {
  CheckPlatformMiddleware(DeviceService deviceService)
      : super((store, action, next) async {
          next(action);

          final nextAction = StorePlatform(value: deviceService.platformType);
          store.dispatch(nextAction);
        });
}
