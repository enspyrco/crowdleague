import 'package:crowdleague/actions/conversations/retrieve_new_conversation_suggestions.dart';
import 'package:crowdleague/actions/conversations/update_new_conversation_page.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:redux/redux.dart';

class RetrieveNewConversationSuggestionsMiddleware
    extends TypedMiddleware<AppState, RetrieveNewConversationSuggestions> {
  RetrieveNewConversationSuggestionsMiddleware(DatabaseService databaseService)
      : super((store, action, next) async {
          next(action);

          store.dispatch(UpdateNewConversationPage(waiting: true));
          store.dispatch(
              await databaseService.retrieveNewConversationSuggestions);
          store.dispatch(UpdateNewConversationPage(waiting: false));
        });
}
