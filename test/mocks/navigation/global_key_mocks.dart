import 'package:flutter/widgets.dart';

import 'navigator_state_mocks.dart';

class FakeGlobalKey implements GlobalKey<NavigatorState> {
  final MockNavigatorState mockNavigatorState;

  FakeGlobalKey(this.mockNavigatorState);

  @override
  NavigatorState get currentState => mockNavigatorState;

  @override
  // TODO: implement currentContext
  BuildContext get currentContext => throw UnimplementedError();

  @override
  // TODO: implement currentWidget
  Widget get currentWidget => throw UnimplementedError();
}
