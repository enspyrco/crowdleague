import 'dart:async';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';

class FakeStore extends Fake implements Store<AppState> {
  @override
  dynamic dispatch(dynamic action) {
    return ReduxAction;
  }
}

class MockStore extends Mock implements Store<AppState> {}

/// A [Store] with no reducers that takes an optional [AppState] and
/// keeps a list of dispatched actions that can be queried.
class DispatchVerifyingStore implements Store<AppState> {
  DispatchVerifyingStore({AppState initialState})
      : _state = initialState ?? AppState.init(),
        _changeController = StreamController.broadcast(),
        reducer = null;

  // The list of dispatched actions that can be queried by a test.
  List<ReduxAction> dispatchedActions = <ReduxAction>[];

  // We must override the reducer as a var in order to extend Store
  // but in our case it is always null.
  @override
  var reducer;

  // We keep our own state so we can have a default value
  final AppState _state;

  // We need a StreamController to provide the onChange method
  final StreamController<AppState> _changeController;

  // Override dispatch to just add the action to the list.
  @override
  dynamic dispatch(dynamic action) {
    dispatchedActions.add(action as ReduxAction);
  }

  @override
  Stream<AppState> get onChange => _changeController.stream;

  @override
  AppState get state => _state;

  @override
  Future teardown() => _changeController.close();
}
