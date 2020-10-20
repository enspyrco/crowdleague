import 'package:flutter/widgets.dart';

import 'navigator_state_mocks.dart';

class FakeGlobalKey implements GlobalKey<NavigatorState> {
  final MockNavigatorState mockNavigatorState;

  FakeGlobalKey(this.mockNavigatorState);

  @override
  NavigatorState get currentState => mockNavigatorState;

  @override
  BuildContext get currentContext => throw UnimplementedError();

  @override
  Widget get currentWidget => throw UnimplementedError();
}
