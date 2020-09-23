import 'package:crowdleague/actions/profile/upload_profile_pic.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/storage_service.dart';
import 'package:redux/redux.dart';

class UploadProfilePicMiddleware
    extends TypedMiddleware<AppState, UploadProfilePic> {
  UploadProfilePicMiddleware(StorageService storageService)
      : super((store, action, next) async {
          next(action);

          final stream = storageService.uploadProfilePic(
              store.state.user.id, action.filePath);

          stream.listen((event) {
            store.dispatch(event);
          });
        });
}
