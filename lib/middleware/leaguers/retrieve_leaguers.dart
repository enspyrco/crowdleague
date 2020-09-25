import 'package:crowdleague/actions/conversations/update_new_conversation_page.dart';
import 'package:crowdleague/actions/leaguers/retrieve_leaguers.dart';
import 'package:crowdleague/enums/new_conversation_page_leaguers_state.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:redux/redux.dart';

class RetrieveLeaguersMiddleware
    extends TypedMiddleware<AppState, RetrieveLeaguers> {
  RetrieveLeaguersMiddleware(DatabaseService databaseService)
      : super((store, action, next) async {
          next(action);

          //
          store.dispatch(UpdateNewConversationPage(
              state: NewConversationPageLeaguersState.waiting));
          store.dispatch(await databaseService.retrieveLeaguers);
          store.dispatch(UpdateNewConversationPage(
              state: NewConversationPageLeaguersState.ready));
        });
}
