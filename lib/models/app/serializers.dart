import 'package:built_collection/built_collection.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:crowdleague/actions/auth/sign_out_user.dart';
import 'package:crowdleague/actions/auth/store_user.dart';
import 'package:crowdleague/actions/conversations/create_conversation.dart';
import 'package:crowdleague/actions/conversations/disregard_messages.dart';
import 'package:crowdleague/actions/conversations/leave_conversation.dart';
import 'package:crowdleague/actions/conversations/observe_messages.dart';
import 'package:crowdleague/actions/conversations/store_conversations.dart';
import 'package:crowdleague/actions/conversations/store_messages.dart';
import 'package:crowdleague/actions/conversations/store_selected_conversation.dart';
import 'package:crowdleague/actions/conversations/update_new_conversation_page.dart';
import 'package:crowdleague/actions/database/plumb_database_stream.dart';
import 'package:crowdleague/actions/functions/disregard_processing_failures.dart';
import 'package:crowdleague/actions/functions/observe_processing_failures.dart';
import 'package:crowdleague/actions/functions/store_processing_failures.dart';
import 'package:crowdleague/actions/functions/update_processing_failure.dart';
import 'package:crowdleague/actions/leaguers/retrieve_leaguers.dart';
import 'package:crowdleague/actions/leaguers/store_leaguers.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/actions/auth/clear_user_data.dart';
import 'package:crowdleague/actions/auth/observe_auth_state.dart';
import 'package:crowdleague/actions/auth/sign_in_with_email.dart';
import 'package:crowdleague/actions/auth/sign_up_with_email.dart';
import 'package:crowdleague/actions/auth/update_other_auth_options_page.dart';
import 'package:crowdleague/actions/navigation/navigate_to.dart';
import 'package:crowdleague/actions/navigation/navigator_replace_current.dart';
import 'package:crowdleague/actions/navigation/record_added_route_info.dart';
import 'package:crowdleague/actions/navigation/record_removed_route_info.dart';
import 'package:crowdleague/actions/navigation/record_replaced_route_info.dart';
import 'package:crowdleague/actions/navigation/remove_problem.dart';
import 'package:crowdleague/actions/navigation/store_nav_bar_selection.dart';
import 'package:crowdleague/actions/notifications/print_fcm_token.dart';
import 'package:crowdleague/actions/notifications/request_fcm_permissions.dart';
import 'package:crowdleague/actions/profile/delete_profile_pic.dart';
import 'package:crowdleague/actions/profile/disregard_profile.dart';
import 'package:crowdleague/actions/profile/disregard_profile_pics.dart';
import 'package:crowdleague/actions/profile/observe_profile.dart';
import 'package:crowdleague/actions/profile/observe_profile_pics.dart';
import 'package:crowdleague/actions/profile/select_profile_pic.dart';
import 'package:crowdleague/actions/profile/store_profile_pics.dart';
import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/actions/themes/store_brightness_mode.dart';
import 'package:crowdleague/actions/themes/store_theme_colors.dart';
import 'package:crowdleague/enums/processing_failure_type.dart';
import 'package:crowdleague/enums/storage/upload_task_state.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/app/settings.dart';
import 'package:crowdleague/models/auth/provider_info.dart';
import 'package:crowdleague/models/auth/vm_auth_page.dart';
import 'package:crowdleague/models/auth/vm_other_auth_options_page.dart';
import 'package:crowdleague/models/conversations/conversation/message.dart';
import 'package:crowdleague/models/conversations/conversation/vm_conversation_page.dart';
import 'package:crowdleague/models/conversations/conversation_summary.dart';
import 'package:crowdleague/models/conversations/new_conversation/vm_new_conversation_leaguers.dart';
import 'package:crowdleague/models/conversations/new_conversation/vm_new_conversation_page.dart';
import 'package:crowdleague/models/conversations/new_conversation/vm_new_conversation_selections.dart';
import 'package:crowdleague/models/conversations/vm_conversation_summaries_page.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/enums/email_auth_mode.dart';
import 'package:crowdleague/enums/nav_bar_selection.dart';
import 'package:crowdleague/enums/new_conversation_page_leaguers_state.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/enums/themes/brightness_mode.dart';
import 'package:crowdleague/enums/themes/theme_brightness.dart';
import 'package:crowdleague/models/functions/processing_failure.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';
import 'package:crowdleague/models/navigation/problem.dart';
import 'package:crowdleague/models/auth/user.dart';
import 'package:crowdleague/models/navigation/route_info.dart';
import 'package:crowdleague/models/profile/profile_pic.dart';
import 'package:crowdleague/models/profile/vm_profile_page.dart';
import 'package:crowdleague/models/storage/upload_task.dart';
import 'package:crowdleague/models/themes/theme_colors.dart';
import 'package:crowdleague/models/themes/theme_set.dart';

part 'serializers.g.dart';

/// Once per app, define a top level "Serializer" to gather together
/// all the generated serializers.
///
/// Collection of generated serializers for the CrowdLeague app
@SerializersFor([
  AddProblem,
  RemoveProblem,
  AppState,
  ObserveAuthState,
  RequestFCMPermissions,
  PrintFCMToken,
  ClearUserData,
  UpdateOtherAuthOptionsPage,
  SignInWithEmail,
  SignUpWithEmail,
  SignOutUser,
  RecordAddedRouteInfo,
  RecordRemovedRouteInfo,
  RecordReplacedRouteInfo,
  StoreUser,
  StoreNavBarSelection,
  StoreConversations,
  StoreSelectedConversation,
  LeaveConversation,
  UpdateNewConversationPage,
  RetrieveLeaguers,
  StoreLeaguers,
  CreateConversation,
  NavigateTo,
  NavigatorReplaceCurrent,
  ObserveMessages,
  StoreMessages,
  DisregardMessages,
  StoreBrightnessMode,
  StoreThemeColors,
  ObserveProfile,
  DisregardProfile,
  ObserveProfilePics,
  DisregardProfilePics,
  StoreProfilePics,
  SelectProfilePic,
  UpdateProfilePage,
  PlumbDatabaseStream,
  DeleteProfilePic,
  ObserveProcessingFailures,
  DisregardProcessingFailures,
  StoreProcessingFailures,
  UpdateProcessingFailure,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..add(Iso8601DateTimeSerializer())
      ..addBuilderFactory(const FullType(BuiltList, [FullType(Leaguer)]),
          () => ListBuilder<Leaguer>()))
    .build();
