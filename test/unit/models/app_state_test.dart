import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/app/settings.dart';
import 'package:crowdleague/models/auth/vm_other_auth_options_page.dart';
import 'package:crowdleague/models/conversations/new_conversation/vm_new_conversation_page.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/enums/nav_bar_selection.dart';
import 'package:crowdleague/models/profile/vm_profile_page.dart';
import 'package:crowdleague/models/storage/upload_task.dart';
import 'package:test/test.dart';

import '../../mocks/models/problem_mocks.dart';
import '../../mocks/models/user_mocks.dart';
import '../../mocks/storage/upload_task_mocks.dart';

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
        ..navBarSelection = NavBarSelection.home
        ..settings = Settings.initBuilder()
        ..otherAuthOptionsPage = VmOtherAuthOptionsPage.initBuilder()
        ..newConversationsPage = VmNewConversationPage.initBuilder()
        ..profilePage = VmProfilePage.initBuilder()
        ..conversationPage.messageText = ''
        ..problems.add(mockProblem)
        ..user.replace(mockUser));

      expect(appState.authPage.step, AuthStep.waitingForInput);
      expect(appState.problems, [mockProblem]);
      expect(appState.user, mockUser);
    });

    // currently just checks that toJson executes and produces a
    // Map<String,Object> which is limited but useful smoke test
    // TODO: check that that json produced is as expected
    test('toJson produces correct json string', () {
      final appState = AppState((b) => b
        ..authPage.step = AuthStep.waitingForInput
        ..navBarSelection = NavBarSelection.home
        ..settings = Settings.initBuilder()
        ..otherAuthOptionsPage = VmOtherAuthOptionsPage.initBuilder()
        ..newConversationsPage = VmNewConversationPage.initBuilder()
        ..profilePage = VmProfilePage.initBuilder()
        ..conversationPage.messageText = ''
        ..problems.add(mockProblem)
        ..user.replace(mockUser));

      expect(appState.toJson() is Map<String, Object>, true);
    });

    test('Adding and removing upload tasks from uploadTasksMap works', () {
      final appState = AppState.init();

      final nextState =
          appState.rebuild((b) => b..uploadTasksMap['1'] = mockUploadTask1);

      expect(nextState.uploadTasksMap.length, 1);

      final finalState =
          nextState.rebuild((b) => b..uploadTasksMap.remove('1'));

      expect(finalState.uploadTasksMap.length, 0);
    });
  });
}
