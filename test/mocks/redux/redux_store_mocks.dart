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

class DispatchVerifyingStore implements Store<AppState> {
  @override
  var reducer;

  final AppState _state;
  List<ReduxAction> dispatchedActions = <ReduxAction>[];
  final StreamController<AppState> _changeController;

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

  DispatchVerifyingStore({AppState initialState})
      : _state = initialState ?? AppState.init(),
        _changeController = StreamController.broadcast(),
        reducer = null;
}
