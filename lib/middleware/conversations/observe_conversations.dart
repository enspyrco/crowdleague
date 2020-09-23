import 'package:crowdleague/actions/conversations/observe_conversations.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:redux/redux.dart';

class ObserveConversationsMiddleware
    extends TypedMiddleware<AppState, ObserveConversations> {
  ObserveConversationsMiddleware(DatabaseService databaseService)
      : super((store, action, next) async {
          next(action);

          databaseService.observeConversations(store.state.user.id);
        });
}
