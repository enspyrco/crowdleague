import 'package:crowdleague/actions/profile/delete_profile_pic.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class DeleteProfilePicReducer extends TypedReducer<AppState, DeleteProfilePic> {
  DeleteProfilePicReducer()
      : super((state, action) {
          // get the index of the profile pic
          final index = state.profilePage.profilePics.indexOf(action.pic);

          // update the item in the list to have the deleting state
          return state.rebuild((b) => b
            ..profilePage.profilePics[index] = b.profilePage.profilePics[index]
                .rebuild((b) => b..deleting = true));
        });
}
