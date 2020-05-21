import 'package:crowdleague/actions/device/pick_profile_pic.dart';
import 'package:crowdleague/actions/storage/upload_profile_pic.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/device_service.dart';
import 'package:redux/redux.dart';

/// Middleware is used for a variety of things:
/// - Logging
/// - Async calls (database, network)
/// - Calling to system frameworks
///
/// These are performed when actions are dispatched to the Store
///
/// The output of an action can perform another action using the [NextDispatcher]
///
List<Middleware<AppState>> createDeviceMiddleware(
    {DeviceService deviceService}) {
  return [
    TypedMiddleware<AppState, PickProfilePic>(
      _pickProfilePic(deviceService),
    ),
  ];
}

void Function(Store<AppState> store, PickProfilePic action, NextDispatcher next)
    _pickProfilePic(DeviceService deviceService) {
  return (Store<AppState> store, PickProfilePic action,
      NextDispatcher next) async {
    next(action);

    final filePath = await deviceService.pickProfilePic();
    store.dispatch(UploadProfilePic((b) => b..filePath = filePath));
  };
}
