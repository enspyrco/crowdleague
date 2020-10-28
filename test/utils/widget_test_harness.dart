import 'package:crowdleague/models/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../mocks/redux/redux_store_mocks.dart';

/// A test harness to wrap a widget under test and provide all the functionality
/// that a test may want in order to interact with the widget or check for
/// expected values and behaviour.
class WidgetTestHarness {
  final Store<AppState> _store;
  final Widget _widgetUnderTest;

  WidgetTestHarness(
      {@required Widget widgetUnderTest,
      Store<AppState> store,
      dynamic Function(AppStateBuilder) stateUpdates})
      : _store = store ?? FakeStore(),
        _widgetUnderTest = widgetUnderTest {
    if (stateUpdates != null) {
      _store.state.rebuild(stateUpdates);
    }
  }

  Widget get widget => StoreProvider<AppState>(
      store: _store, child: MaterialApp(home: _widgetUnderTest));

  AppState get state => _store.state;
}
