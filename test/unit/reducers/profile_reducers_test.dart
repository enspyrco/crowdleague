import 'package:crowdleague/actions/profile/store_profile_pics.dart';
import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/profile_reducers.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';

import '../../mocks/profile_pic_mocks.dart';

void main() {
  group('Profile Reducer', () {
    /// The 'selectingProfilePic' state of the profile page view model
    /// should only be set to true if thre are options (ie. more than one) to
    /// choose from. Setting to false should always work.
    test('_updateProfilePage only updates selectingProfilePic if appropriate',
        () {
      // create a basic store with the profile reducers and the initial state
      final store = Store<AppState>(
        combineReducers<AppState>(
            <AppState Function(AppState, dynamic)>[...profileReducers]),
        initialState: AppState.init(),
      );

      // before the action, 'selecting' should be false and the list empty
      expect(store.state.profilePage.selectingProfilePic, false);
      expect(store.state.profilePage.profilePics.length, 0);

      // dispatch action to update the profile page 'selecting' state
      store.dispatch(UpdateProfilePage((b) => b.selectingProfilePic = true));

      // check that 'selecting' state was not updated
      expect(store.state.profilePage.selectingProfilePic, false);

      // store a list with a single profile pic
      store.dispatch(
          StoreProfilePics((b) => b..profilePics.add(mockProfilePic1)));

      // check list size is now 1
      expect(store.state.profilePage.profilePics.length, 1);

      // dispatch action to update the profile page 'selecting' state
      store.dispatch(UpdateProfilePage((b) => b.selectingProfilePic = true));

      // check that 'selecting' state was still not updated
      expect(store.state.profilePage.selectingProfilePic, false);

      // store a list with two profile pics
      store.dispatch(StoreProfilePics(
          (b) => b..profilePics.addAll([mockProfilePic1, mockProfilePic2])));

      // check list size is now 2
      expect(store.state.profilePage.profilePics.length, 2);

      // dispatch action to update the profile page 'selecting' state
      store.dispatch(UpdateProfilePage((b) => b.selectingProfilePic = true));

      // check that the 'selecting' state has now been set
      expect(store.state.profilePage.selectingProfilePic, true);

      // store a list with one profile pic
      store.dispatch(
          StoreProfilePics((b) => b..profilePics.add(mockProfilePic2)));

      // check list size is now 1 and 'selecting' state is still true
      expect(store.state.profilePage.profilePics.length, 1);
      expect(store.state.profilePage.selectingProfilePic, true);

      // dispatch action to update the profile page 'selecting' state
      store.dispatch(UpdateProfilePage((b) => b.selectingProfilePic = false));

      // check that the 'selecting' state was set
      expect(store.state.profilePage.selectingProfilePic, false);
    });
  });
}
