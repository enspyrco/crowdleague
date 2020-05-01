import 'package:crowdleague/models/app_state.dart';
import 'package:crowdleague/models/enums/auth_step.dart';
import 'package:crowdleague/models/vm_other_auth_options_page.dart';
import 'package:test/test.dart';

import '../../mocks/problem_mocks.dart';
import '../../mocks/user_mocks.dart';

void main() {
  ///
  /// -- Non-nullable
  ///
  /// int authStep
  /// int themeMode
  /// int navIndex
  /// OtherAuthOptionsViewModel otherAuthOptions
  ///
  /// -- nullable
  ///
  /// BuiltList<Problem> problems
  /// User user

  group('ApState', () {
    test('members take expected values', () {
      final appState = AppState((b) => b
        ..authPage.step = AuthStep.waitingForInput
        ..themeMode = 0
        ..navIndex = 0
        ..otherAuthOptionsPage = VmOtherAuthOptionsPage.initBuilder()
        ..problems.add(mockProblem)
        ..user.replace(mockUser));

      expect(appState.authPage.step, AuthStep.waitingForInput);
      expect(appState.themeMode, 0);
      expect(appState.problems, [mockProblem]);
      expect(appState.user, mockUser);
    });

    // currently just checks that toJson executes and produces a
    // Map<String,Object> which is limited but useful smoke test
    // TODO: check that that json produced is as expected
    test('toJson produces correct json string', () {
      final appState = AppState((b) => b
        ..authPage.step = AuthStep.waitingForInput
        ..themeMode = 0
        ..navIndex = 0
        ..otherAuthOptionsPage = VmOtherAuthOptionsPage.initBuilder()
        ..problems.add(mockProblem)
        ..user.replace(mockUser));

      expect(appState.toJson() is Map<String, Object>, true);
    });
  });
}
