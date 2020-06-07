import 'package:flutter/widgets.dart';

import 'package:mockito/mockito.dart';

class MockOverlayState extends Mock implements OverlayState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'minLevel: $minLevel';
  }
}
