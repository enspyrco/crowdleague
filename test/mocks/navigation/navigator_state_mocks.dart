import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';

import 'overlay_state_mocks.dart';

/// A mocked object that implements [NavigatorState]
///
/// Overrides the [overlay] getter and returns a mocked [OverlayState]
///
class MockNavigatorState extends Mock implements NavigatorState {
  @override
  OverlayState get overlay => MockOverlayState();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'minLevel: $minLevel';
  }
}
