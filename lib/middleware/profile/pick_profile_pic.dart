import 'package:crowdleague/actions/device/pick_profile_pic.dart';
import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/actions/profile/upload_profile_pic.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/device_service.dart';
import 'package:redux/redux.dart';

class PickProfilePicMiddleware
    extends TypedMiddleware<AppState, PickProfilePic> {
  PickProfilePicMiddleware(DeviceService deviceService)
      : super((store, action, next) async {
          // If a ProfilePic is being picked or uploaded we swallow the action
          // and don't start an upload
          // next(action);

          // check that we are not picking or uploading
          if (!store.state.profilePage.pickingProfilePic &&
              store.state.profilePage.uploadingProfilePicId == null) {
            next(action);

            final filePath = await deviceService.pickProfilePic();
            store.dispatch(
                UpdateProfilePage((b) => b..pickingProfilePic = false));
            if (filePath != null) {
              store.dispatch(UploadProfilePic((b) => b..filePath = filePath));
            }
          }
        });
}
