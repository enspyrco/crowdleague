import 'package:crowdleague/actions/device/pick_profile_pic.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class PickProfilePicReducer extends TypedReducer<AppState, PickProfilePic> {
  PickProfilePicReducer()
      : super((state, action) =>
            state.rebuild((b) => b..profilePage.pickingProfilePic = true));
}
