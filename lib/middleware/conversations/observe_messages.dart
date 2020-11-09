import 'package:crowdleague/actions/conversations/observe_messages.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:redux/redux.dart';

class ObserveMessagesMiddleware
    extends TypedMiddleware<AppState, ObserveMessages> {
  ObserveMessagesMiddleware(DatabaseService databaseService)
      : super((store, action, next) async {
          next(action);

          /// the function calls listen on the firestore and keeps the stream open
          /// until disregardMessages is called
          databaseService
              .observeMessages(store.state.messagesPage.summary.conversationId);
        });
}
