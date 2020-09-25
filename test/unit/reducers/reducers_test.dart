import 'package:crowdleague/actions/auth/clear_user_data.dart';
import 'package:crowdleague/actions/auth/store_auth_step.dart';
import 'package:crowdleague/actions/auth/store_user.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';

import '../../mocks/models/problem_mocks.dart';
import '../../mocks/models/user_mocks.dart';

void main() {
  group('Reducer', () {
    test('_addProblem adds to the list', () {
      // create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // dispatch action to add a problem
      store.dispatch(AddProblem(problem: mockProblem));

      // check that the store has the expected value
      expect(store.state.problems.length, 1);
      final problem = store.state.problems.first;
      expect(problem, mockProblem);
    });

    test('_clearUserData stores an empty user object', () {
      // create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // dispatch action to store a user object
      store.dispatch(StoreUser(user: mockUser));

      // check that the store has the expected value
      expect(store.state.user, mockUser);

      // TODO: make a mock AppState full of random data rather than just
      // changing the user object

      // dispatch action to store auth state
      store.dispatch(ClearUserData());

      // check that the store has the expected value
      expect(store.state, AppState.init());
    });

    test('_storeUser stores the given user object', () {
      // create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // dispatch action to store auth state
      store.dispatch(StoreUser(user: mockUser));

      // check that the store has the expected value
      expect(store.state.user, mockUser);
    });

    test('_storeAuthStep stores the auth step', () {
      // create a basic store with the app reducers
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // dispatch action to store auth step
      store.dispatch(StoreAuthStep(step: AuthStep.signingInWithApple));

      // check that the store has the expected value
      expect(store.state.authPage.step, AuthStep.signingInWithApple);
    });

    // test(
    //     '_storePodcastSummaries correctly stores summaries in the StorePodcastSummaries action',
    //     () async {
    //   // create a basic store with the app reducers
    //   final store = Store<AppState>(
    //     appReducer,
    //     initialState: AppState.init(),
    //   );

    //   final summary = await getInTheDarkSummary();

    //   // dispatch action to store summaries
    //   store.dispatch(
    //       StorePodcastSummaries((b) => b..summaries = ListBuilder([summary])));

    //   // check that the store has the expected value
    //   expect(store.state.podcastSummaries.first, summary);
    // });

    // test('_storeThemeMode correctly stores themeMode', () {
    //   // create a basic store with the app reducers
    //   final store = Store<AppState>(
    //     appReducer,
    //     initialState: AppState.init(),
    //   );

    //   // dispatch action to store themeMode
    //   store.dispatch(StoreThemeMode((b) => b..themeMode = 0));

    //   // check that the store has the expected value
    //   expect(store.state.themeMode, 0);

    //   // dispatch action to store themeMode
    //   store.dispatch(StoreThemeMode((b) => b..themeMode = 1));

    //   // check that the store has the expected value
    //   expect(store.state.themeMode, 1);
    // });

    // test('_storeFeed correctly stores a feed', () async {
    //   // create a basic store with the app reducers
    //   final store = Store<AppState>(
    //     appReducer,
    //     initialState: AppState.init(),
    //   );

    //   final feed = await getInTheDarkFeed();

    //   // dispatch action to store the feed
    //   store.dispatch(StoreFeed((b) => b..feed = feed.toBuilder()));

    //   // check that the store has the expected value
    //   expect(store.state.detailVM.feed, feed);
    // });

    // test('_storeTrack correctly stores a track', () async {
    //   // create a basic store with the app reducers
    //   final store = Store<AppState>(
    //     appReducer,
    //     initialState: AppState.init(),
    //   );

    //   // use a pre-defined track from the test data
    //   final track = in_the_dark_s2e18_track;

    //   // dispatch action to store the track
    //   store.dispatch(StoreTrack((b) => b..track = track.toBuilder()));

    //   // check that the store has the expected value
    //   expect(store.state.track, track);
    // });

    // test('_storeTrackState sets the state for the current track', () async {
    //   // create a basic store with the app reducers
    //   final store = Store<AppState>(
    //     appReducer,
    //     initialState: AppState.init(),
    //   );

    //   // use a pre-defined track from the test data
    //   final track = in_the_dark_s2e18_track;

    //   // dispatch action to store the track
    //   store.dispatch(StoreTrack((b) => b..track = track.toBuilder()));

    //   // check the initial track state
    //   expect(store.state.track.state, TrackStateEnum.nothing);

    //   // dispatch to update the track state
    //   store.dispatch(StoreTrackState((b) => b..state = TrackStateEnum.playing));

    //   // rebuild the test data track with the updated TrackState
    //   final updatedTrack =
    //       track.rebuild((b) => b..state = TrackStateEnum.playing);

    //   // check that the store has the expected value
    //   expect(store.state.track, updatedTrack);
    // });

    // test('_storeTrackDuration sets the duration for the current track',
    //     () async {
    //   // create a basic store with the app reducers
    //   final store = Store<AppState>(
    //     appReducer,
    //     initialState: AppState.init(),
    //   );

    //   // use a pre-defined track from the test data
    //   final track = in_the_dark_s2e18_track;

    //   // dispatch action to store the track
    //   store.dispatch(StoreTrack((b) => b..track = track.toBuilder()));

    //   // check the initial track duration
    //   expect(store.state.track.duration, null);

    //   // dispatch to update the track duration
    //   store.dispatch(StoreTrackDuration((b) => b..duration = 100.3));

    //   // rebuild the test data track with the updated duration
    //   final updatedTrack = track.rebuild((b) => b..duration = 100.3);

    //   // check that the store has the expected value
    //   expect(store.state.track, updatedTrack);
    // });

    // test('_storeTrackPosition sets the position for the current track',
    //     () async {
    //   // create a basic store with the app reducers
    //   final store = Store<AppState>(
    //     appReducer,
    //     initialState: AppState.init(),
    //   );

    //   // use a pre-defined track from the test data
    //   final track = in_the_dark_s2e18_track;

    //   // dispatch action to store the track
    //   store.dispatch(StoreTrack((b) => b..track = track.toBuilder()));

    //   // check the initial track position
    //   expect(store.state.track.position, null);

    //   // dispatch to update the track position
    //   store.dispatch(StoreTrackPosition((b) => b..position = 55.5));

    //   // rebuild the test data track with the updated position
    //   final updatedTrack = track.rebuild((b) => b..position = 55.5);

    //   // check that the store has the expected value
    //   expect(store.state.track, updatedTrack);
    // });
  });
}
