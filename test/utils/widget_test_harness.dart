import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../mocks/redux/redux_store_mocks.dart';

/// A test harness to wrap a widget under test and provide all the functionality
/// that a test may want in order to interact with the widget or check for
/// expected values and behaviour.
class WidgetTestHarness {
  final FakeStore _fakeStore;
  final Widget _widgetUnderTest;

  WidgetTestHarness(
      {@required Widget widgetUnderTest,
      FakeStore fakeStore,
      dynamic Function(AppStateBuilder) stateUpdates})
      : _fakeStore = fakeStore ?? FakeStore(),
        _widgetUnderTest = widgetUnderTest {
    if (stateUpdates != null) {
      _fakeStore.updateState(stateUpdates);
    }
  }

  void updateAppState(dynamic Function(AppStateBuilder) updates) =>
      _fakeStore.updateState(updates);

  Widget get widget => StoreProvider<AppState>(
      store: _fakeStore, child: MaterialApp(home: _widgetUnderTest));

  AppState get state => _fakeStore.state;

  List<ReduxAction> get receivedActions => _fakeStore.dispatchedActions;
}
