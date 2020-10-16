import 'package:crowdleague/actions/device/pick_profile_pic.dart';
import 'package:crowdleague/middleware/profile/pick_profile_pic.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';

import '../../mocks/models/user_mocks.dart';
import '../../mocks/services/device_service_mocks.dart';

void main() {
  /// The _pickProfilePic middleware should not call deviceService.pickProfilePic
  /// if a pic is already being picked
  group('Profile Middleware', () {
    test('_pickProfilePic respects picking state', () async {
      final mockService = MockDeviceService();

      // create a basic store with mocked out middleware
      final store = Store<AppState>(appReducer,
          initialState: AppState.init(),
          middleware: [PickProfilePicMiddleware(mockService)]);

      // dispatch action to test middleware
      store.dispatch(PickProfilePic());

      // check that the middleware called the device service function
      verify(mockService.pickProfilePic());

      // dispatch action to test middleware
      store.dispatch(PickProfilePic());

      // check that the middleware did not call the device service function again
      verifyNever(mockService.pickProfilePic());
    });

    /// The _pickProfilePic middleware should not call deviceService.pickProfilePic
    /// if there is an upload in progress (indicated by
    /// profilePage.uploadingProfilePicId having a value)
    test('_pickProfilePic respects uploading state', () async {
      final mockDeviceService = MockDeviceService();

      // setup an initial state with a signed in user (id needed for uploading)
      final initialState = AppState.init().rebuild((b) => b
        ..user.replace(mockUser)
        ..profilePage.uploadingProfilePicId = 'pic_id');

      // create a basic store with mocked out middleware
      final store = Store<AppState>(appReducer,
          initialState: initialState,
          middleware: [PickProfilePicMiddleware(mockDeviceService)]);

      // dispatch action to test middleware
      store.dispatch(PickProfilePic());

      // check that the middleware did not call the device service function again
      verifyNever(mockDeviceService.pickProfilePic());
    });

    // test('_uploadProfilePic', () async {
    //   final mockDeviceService = MockDeviceService();
    //   final controller = StreamController<ReduxAction>();
    //   final fakeStorageService = FakeStorageService(controller);

    //   // setup an initial state with a signed in user (id needed for uploading)
    //   final initialState =
    //       AppState.init().rebuild((b) => b..user.replace(mockUser));

    //   // create a basic store with mocked out middleware
    //   final store = Store<AppState>(appReducer,
    //       initialState: initialState,
    //       middleware: createProfileMiddleware(
    //           deviceService: mockDeviceService,
    //           storageService: fakeStorageService));

    //   // dispatch action to start an upload
    //   // middleware calls storageService.uploadProfilePic
    //   store.dispatch(UploadProfilePic((b) => b..filePath = 'path'));

    //   controller.add(mockUpdateUploadTask);
    // });
  });
}
