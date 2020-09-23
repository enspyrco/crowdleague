import 'package:crowdleague/actions/conversations/disregard_conversations.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:redux/redux.dart';

class DisregardConversationsMiddleware
    extends TypedMiddleware<AppState, DisregardConversations> {
  DisregardConversationsMiddleware(DatabaseService databaseService)
      : super((store, action, next) async {
          next(action);

          databaseService.disregardConversations();
        });
}
