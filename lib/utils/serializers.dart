import 'package:built_collection/built_collection.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:crowdleague/actions/auth/clear_user_data.dart';
import 'package:crowdleague/actions/auth/observe_auth_state.dart';
import 'package:crowdleague/actions/auth/sign_in_with_apple.dart';
import 'package:crowdleague/actions/auth/sign_in_with_email.dart';
import 'package:crowdleague/actions/auth/sign_in_with_google.dart';
import 'package:crowdleague/actions/auth/sign_out_user.dart';
import 'package:crowdleague/actions/auth/sign_up_with_email.dart';
import 'package:crowdleague/actions/auth/store_auth_step.dart';
import 'package:crowdleague/actions/auth/store_user.dart';
import 'package:crowdleague/actions/auth/update_email_auth_options_page.dart';
import 'package:crowdleague/actions/conversations/create_conversation.dart';
import 'package:crowdleague/actions/conversations/disregard_conversations.dart';
import 'package:crowdleague/actions/conversations/disregard_messages.dart';
import 'package:crowdleague/actions/conversations/leave_conversation.dart';
import 'package:crowdleague/actions/conversations/observe_conversations.dart';
import 'package:crowdleague/actions/conversations/observe_messages.dart';
import 'package:crowdleague/actions/conversations/retrieve_new_conversation_suggestions.dart';
import 'package:crowdleague/actions/conversations/store_conversations.dart';
import 'package:crowdleague/actions/conversations/store_messages.dart';
import 'package:crowdleague/actions/conversations/store_selected_conversation.dart';
import 'package:crowdleague/actions/conversations/update_new_conversation_page.dart';
import 'package:crowdleague/actions/database/plumb_database_stream.dart';
import 'package:crowdleague/actions/device/check_platform.dart';
import 'package:crowdleague/actions/device/pick_profile_pic.dart';
import 'package:crowdleague/actions/device/store_platform.dart';
import 'package:crowdleague/actions/functions/disregard_processing_failures.dart';
import 'package:crowdleague/actions/functions/observe_processing_failures.dart';
import 'package:crowdleague/actions/functions/store_processing_failures.dart';
import 'package:crowdleague/actions/functions/update_processing_failure.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/actions/navigation/push_page.dart';
import 'package:crowdleague/actions/navigation/remove_current_page.dart';
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
import 'package:crowdleague/actions/profile/upload_profile_pic.dart';
import 'package:crowdleague/actions/settings/store_brightness_mode.dart';
import 'package:crowdleague/actions/settings/store_theme_colors.dart';
import 'package:crowdleague/actions/storage/update_upload_task.dart';
import 'package:crowdleague/enums/auth/auth_step.dart';
import 'package:crowdleague/enums/auth/auto_validate.dart';
import 'package:crowdleague/enums/auth/email_auth_mode.dart';
import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:crowdleague/enums/navigation/nav_bar_selection.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/enums/processing_failure_type.dart';
import 'package:crowdleague/enums/settings/brightness_mode.dart';
import 'package:crowdleague/enums/settings/theme_brightness.dart';
import 'package:crowdleague/enums/storage/upload_task_state.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/app/system_info.dart';
import 'package:crowdleague/models/auth/provider_info.dart';
import 'package:crowdleague/models/auth/user.dart';
import 'package:crowdleague/models/auth/vm_auth_page.dart';
import 'package:crowdleague/models/auth/vm_email_auth_options_page.dart';
import 'package:crowdleague/models/conversations/conversation/message.dart';
import 'package:crowdleague/models/conversations/conversation/vm_messages_page.dart';
import 'package:crowdleague/models/conversations/conversation_summary.dart';
import 'package:crowdleague/models/conversations/new_conversation/vm_new_conversation_page.dart';
import 'package:crowdleague/models/conversations/new_conversation/vm_new_conversation_selections.dart';
import 'package:crowdleague/models/conversations/new_conversation/vm_new_conversation_suggestions.dart';
import 'package:crowdleague/models/conversations/vm_conversation_summaries_page.dart';
import 'package:crowdleague/models/functions/processing_failure.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';
import 'package:crowdleague/models/navigation/page_data/email_auth_page_data.dart';
import 'package:crowdleague/models/navigation/page_data/initial_page_data.dart';
import 'package:crowdleague/models/navigation/page_data/page_data.dart';
import 'package:crowdleague/models/problems/problem.dart';
import 'package:crowdleague/models/profile/profile_pic.dart';
import 'package:crowdleague/models/profile/vm_profile_page.dart';
import 'package:crowdleague/models/settings/settings.dart';
import 'package:crowdleague/models/settings/theme_colors.dart';
import 'package:crowdleague/models/settings/theme_set.dart';
import 'package:crowdleague/models/storage/upload_failure.dart';
import 'package:crowdleague/models/storage/upload_task.dart';

part 'serializers.g.dart';

/// Once per app, define a top level "Serializer" to gather together
/// all the generated serializers.
///
/// Collection of generated serializers for the CrowdLeague app
@SerializersFor([
  AddProblem,
  AppState,
  AutoValidate,
  BrightnessMode,
  CheckPlatform,
  ClearUserData,
  CreateConversation,
  DeleteProfilePic,
  DisregardConversations,
  DisregardMessages,
  DisregardProcessingFailures,
  DisregardProfile,
  DisregardProfilePics,
  EmailAuthPageData,
  InitialPageData,
  LeaveConversation,
  PageData,
  PushPage,
  ObserveAuthState,
  ObserveConversations,
  ObserveMessages,
  ObserveProcessingFailures,
  ObserveProfile,
  ObserveProfilePics,
  PickProfilePic,
  PlatformType,
  PlumbDatabaseStream,
  PushPage,
  PrintFCMToken,
  RequestFCMPermissions,
  RemoveCurrentPage,
  RemoveProblem,
  RetrieveNewConversationSuggestions,
  SelectProfilePic,
  SignInWithApple,
  SignInWithGoogle,
  SignInWithEmail,
  SignUpWithEmail,
  SignOutUser,
  StoreAuthStep,
  StoreBrightnessMode,
  StoreConversations,
  StoreMessages,
  StoreNavBarSelection,
  StorePlatform,
  StoreProcessingFailures,
  StoreProfilePics,
  StoreSelectedConversation,
  StoreThemeColors,
  StoreUser,
  SystemInfo,
  ThemeBrightness,
  UpdateNewConversationPage,
  UpdateEmailAuthOptionsPage,
  UpdateProcessingFailure,
  UpdateProfilePage,
  UpdateUploadTask,
  UploadProfilePic,
  VmEmailAuthOptionsPage
])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..add(Iso8601DateTimeSerializer())
      ..addBuilderFactory(const FullType(BuiltList, [FullType(Leaguer)]),
          () => ListBuilder<Leaguer>()))
    .build();
