import 'package:crowdleague/actions/functions/store_processing_failures.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/actions/navigation/remove_problem.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/auth/clear_user_data.dart';
import 'package:crowdleague/reducers/auth/store_auth_step.dart';
import 'package:crowdleague/reducers/auth/store_user.dart';
import 'package:crowdleague/reducers/auth/update_other_auth_options_page.dart';
import 'package:crowdleague/reducers/conversations/leave_conversation.dart';
import 'package:crowdleague/reducers/conversations/store_conversations.dart';
import 'package:crowdleague/reducers/conversations/store_messages.dart';
import 'package:crowdleague/reducers/conversations/store_selected_conversation.dart';
import 'package:crowdleague/reducers/conversations/update_conversations_page.dart';
import 'package:crowdleague/reducers/conversations/update_new_conversations_page.dart';
import 'package:crowdleague/reducers/device/store_platform.dart';
import 'package:crowdleague/reducers/leaguers/store_leaguers.dart';
import 'package:crowdleague/reducers/navigation/record_added_route_info.dart';
import 'package:crowdleague/reducers/navigation/record_removed_route_info.dart';
import 'package:crowdleague/reducers/navigation/record_replaced_route_info.dart';
import 'package:crowdleague/reducers/navigation/store_nav_bar_selection.dart';
import 'package:crowdleague/reducers/profile/delete_profile_pic.dart';
import 'package:crowdleague/reducers/profile/pick_profile_pic.dart';
import 'package:crowdleague/reducers/profile/store_profile_pics.dart';
import 'package:crowdleague/reducers/profile/update_profile_page.dart';
import 'package:crowdleague/reducers/storage/update_upload_task.dart';
import 'package:crowdleague/reducers/themes/store_brightness_mode.dart';
import 'package:crowdleague/reducers/themes/store_theme_colors.dart';
import 'package:redux/redux.dart';

/// Reducers specify how the application's state changes in response to actions
/// sent to the store. Each reducer returns a new [AppState].
final appReducer =
    combineReducers<AppState>(<AppState Function(AppState, dynamic)>[
  // Auth
  ClearUserDataReducer(),
  StoreAuthStepReducer(),
  StoreUserReducer(),
  UpdateOtherAuthOptionsPageReducer(),
  // Conversations
  LeaveConversationReducer(),
  StoreConversationsReducer(),
  StoreMessagesReducer(),
  StoreSelectedConversationReducer(),
  UpdateConversationPageReducer(),
  UpdateNewConversationPageReducer(),
  // Device
  StorePlatformReducer(),
  // Leaguers
  StoreLeaguersReducer(),
  // Navigation
  RecordAddedRouteInfoReducer(),
  RecordRemovedRouteInfoReducer(),
  RecordReplacedRouteInfoReducer(),
  StoreNavBarSelectionReducer(),
  // Profile
  DeleteProfilePicReducer(),
  PickProfilePicReducer(),
  StoreProfilePicsReducer(),
  UpdateProfilePageReducer(),
  // Storage
  UpdateUploadTaskReducer(),
  // Themes
  StoreBrightnessModeReducer(),
  StoreThemeColorsReducer(),
  // Other (class declarations below)
  AddProblemReducer(),
  RemoveProblemReducer(),
  StoreProcessingFailuresReducer(),
]);

class StoreProcessingFailuresReducer
    extends TypedReducer<AppState, StoreProcessingFailures> {
  StoreProcessingFailuresReducer()
      : super((state, action) => state
            .rebuild((b) => b..processingFailures.replace(action.failures)));
}

class AddProblemReducer extends TypedReducer<AppState, AddProblem> {
  AddProblemReducer()
      : super((state, action) =>
            state.rebuild((b) => b..problems.add(action.problem)));
}

class RemoveProblemReducer extends TypedReducer<AppState, RemoveProblem> {
  RemoveProblemReducer()
      : super((state, action) =>
            state.rebuild((b) => b..problems.remove(action.problem)));
}
