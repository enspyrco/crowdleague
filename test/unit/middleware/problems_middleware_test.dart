import 'dart:async';

import 'package:crowdleague/actions/problems/add_problem.dart';
import 'package:crowdleague/actions/problems/remove_problem.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/middleware/problems_middleware.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';

import '../../mocks/models/problem_mocks.dart';
import '../../mocks/services/navigation_service_mocks.dart';

void main() {
  /// The _displayAddedProblem middleware should not call
  /// [NavigationService.pickProfilePic] if a problem is already being displayed
  group('Problems Middleware', () {
    test(
        ' _displayAddedProblem only displays if no problem already being displayed',
        () async {
      final completer = Completer<ReduxAction>();
      final fakeService = FakeNavigationService(completer);

      // create a basic store with mocked out middleware
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
        middleware: createProblemsMiddleware(
          navigationService: fakeService,
        ),
      );

      // dispatch action to test middleware
      store.dispatch(AddProblem((b) => b..problem.replace(mockProblem)));

      // check the state has been updated to indicate a problem is being displayed
      expect(store.state.displayingProblem, true);
      expect(store.state.problems.last, mockProblem);

      completer.complete(RemoveProblem((b) => b..problem.replace(mockProblem)));

      // check the state has been updated to indivate no problem is being displayed
      expect(store.state.displayingProblem, false);
      // expect(store.state.problems.last, null);

      // // check that the middleware called the navigation service function
      // verify(fakeService.display(mockProblem));

      // dispatch action to test middleware
      // store.dispatch(AddProblem((b) => b..problem.replace(mockProblem)));

      // check that the middleware called the navigation service function
      // verify(fakeService.display(mockProblem));

      // // dispatch action to test middleware
      // store.dispatch(PickProfilePic());

      // // check that the middleware did not call the device service function again
      // verifyNever(mockService.pickProfilePic());
    });

    // /// The _pickProfilePic middleware should not call deviceService.pickProfilePic
    // /// if there is an upload in progress (indicated by
    // /// profilePage.uploadingProfilePicId having a value)
    // test('_pickProfilePic respects uploading state', () async {
    //   final mockDeviceService = MockDeviceService();

    //   // setup an initial state with a signed in user (id needed for uploading)
    //   final initialState = AppState.init().rebuild((b) => b
    //     ..user.replace(mockUser)
    //     ..profilePage.uploadingProfilePicId = 'pic_id');

    //   // create a basic store with mocked out middleware
    //   final store = Store<AppState>(appReducer,
    //       initialState: initialState,
    //       middleware: createProfileMiddleware(
    //         deviceService: mockDeviceService,
    //       ));

    //   // dispatch action to test middleware
    //   store.dispatch(PickProfilePic());

    //   // check that the middleware did not call the device service function again
    //   verifyNever(mockDeviceService.pickProfilePic());
    // });

    // // test('_uploadProfilePic', () async {
    // //   final mockDeviceService = MockDeviceService();
    // //   final controller = StreamController<ReduxAction>();
    // //   final fakeStorageService = FakeStorageService(controller);

    // //   // setup an initial state with a signed in user (id needed for uploading)
    // //   final initialState =
    // //       AppState.init().rebuild((b) => b..user.replace(mockUser));

    // //   // create a basic store with mocked out middleware
    // //   final store = Store<AppState>(appReducer,
    // //       initialState: initialState,
    // //       middleware: createProfileMiddleware(
    // //           deviceService: mockDeviceService,
    // //           storageService: fakeStorageService));

    // //   // dispatch action to start an upload
    // //   // middleware calls storageService.uploadProfilePic
    // //   store.dispatch(UploadProfilePic((b) => b..filePath = 'path'));

    // //   controller.add(mockUpdateUploadTask);
    // // });
  });
}
