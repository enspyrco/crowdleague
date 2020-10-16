import 'package:crowdleague/actions/conversations/leave_conversation.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:redux/redux.dart';

class LeaveConversationMiddleware
    extends TypedMiddleware<AppState, LeaveConversation> {
  LeaveConversationMiddleware(DatabaseService databaseService)
      : super((store, action, next) async {
          next(action);

          /// returns a Future<void>, currently no need to do anything when the
          /// future completes as the list has been updated locally already
          await databaseService.leaveConversation(
              store.state.user.id, action.conversationId);
        });
}
