import 'package:crowdleague/actions/database/plumb_database_stream.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/middleware/auth/observe_auth_state.dart';
import 'package:crowdleague/middleware/auth/sign_in_with_apple.dart';
import 'package:crowdleague/middleware/auth/sign_in_with_email.dart';
import 'package:crowdleague/middleware/auth/sign_in_with_google.dart';
import 'package:crowdleague/middleware/auth/sign_out_user.dart';
import 'package:crowdleague/middleware/auth/sign_up_with_email.dart';
import 'package:crowdleague/middleware/conversations/create_conversation.dart';
import 'package:crowdleague/middleware/conversations/disregard_conversations.dart';
import 'package:crowdleague/middleware/conversations/disregard_messages.dart';
import 'package:crowdleague/middleware/conversations/leave_conversation.dart';
import 'package:crowdleague/middleware/conversations/observe_conversations.dart';
import 'package:crowdleague/middleware/conversations/observe_messages.dart';
import 'package:crowdleague/middleware/conversations/save_message.dart';
import 'package:crowdleague/middleware/device/check_platform.dart';
import 'package:crowdleague/middleware/leaguers/retrieve_leaguers.dart';
import 'package:crowdleague/middleware/notifications/print_f_c_m_token.dart';
import 'package:crowdleague/middleware/notifications/request_f_c_m_permissions.dart';
import 'package:crowdleague/middleware/profile/disregard_profile.dart';
import 'package:crowdleague/middleware/profile/disregard_profile_pics.dart';
import 'package:crowdleague/middleware/profile/observe_profile.dart';
import 'package:crowdleague/middleware/profile/observe_profile_pics.dart';
import 'package:crowdleague/middleware/profile/pick_profile_pic.dart';
import 'package:crowdleague/middleware/profile/select_profile_pic.dart';
import 'package:crowdleague/middleware/profile/upload_profile_pic.dart';
import 'package:crowdleague/middleware/storage/update_upload_task.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:crowdleague/services/device_service.dart';
import 'package:crowdleague/services/notifications_service.dart';
import 'package:crowdleague/services/storage_service.dart';
import 'package:redux/redux.dart';

/// Middleware is used for a variety of things:
/// - Logging
/// - Async calls (database, network)
/// - Calling to system frameworks
///
/// These are performed when actions are dispatched to the Store
///
/// The output of an action can perform another action using the [NextDispatcher]
///
List<Middleware<AppState>> createAppMiddleware(
    {AuthService authService,
    DatabaseService databaseService,
    NotificationsService notificationsService,
    StorageService storageService,
    DeviceService deviceService}) {
  return [
    // Auth
    ObserveAuthStateMiddleware(authService),
    SignInWithAppleMiddleware(authService),
    SignInWithEmailMiddleware(authService),
    SignInWithGoogleMiddleware(authService),
    SignOutUserMiddleware(authService),
    SignUpWithEmailMiddleware(authService),
    // Conversations
    CreateConversationMiddleware(databaseService),
    DisregardConversationsMiddleware(databaseService),
    DisregardMessagesMiddleware(databaseService),
    LeaveConversationMiddleware(databaseService),
    ObserveConversationsMiddleware(databaseService),
    ObserveMessagesMiddleware(databaseService),
    SaveMessageMiddleware(databaseService),
    // Device
    CheckPlatformMiddleware(deviceService),
    // Leaguers
    RetrieveLeaguersMiddleware(databaseService),
    // Notifications
    PrintFCMTokenMiddleware(notificationsService),
    RequestFCMPermissionsMiddleware(notificationsService),
    // Profile
    DisregardProfilePicsMiddleware(databaseService),
    DisregardProfileMiddleware(databaseService),
    ObserveProfilePicsMiddleware(databaseService),
    ObserveProfileMiddleware(databaseService),
    PickProfilePicMiddleware(deviceService),
    SelectProfilePicMiddleware(databaseService),
    UploadProfilePicMiddleware(storageService),
    // Storage
    UpdateUploadTaskMiddleware(),
    // Other (class declaration below)
    PlumbDatabaseStreamMiddleware(databaseService)
  ];
}

class PlumbDatabaseStreamMiddleware
    extends TypedMiddleware<AppState, PlumbDatabaseStream> {
  PlumbDatabaseStreamMiddleware(DatabaseService databaseService)
      : super((store, action, next) async {
          next(action);

          databaseService.storeStream.listen(
            store.dispatch,
            onError: (dynamic error, StackTrace trace) => store.dispatch(
              AddProblem.from(
                  message: error.toString(),
                  traceString: trace.toString(),
                  type: ProblemType.databaseStoreController),
            ),
          );
        });
}
