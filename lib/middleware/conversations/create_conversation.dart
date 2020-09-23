import 'package:crowdleague/actions/conversations/create_conversation.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/actions/navigation/navigator_replace_current.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:redux/redux.dart';

class CreateConversationMiddleware
    extends TypedMiddleware<AppState, CreateConversation> {
  CreateConversationMiddleware(DatabaseService databaseService)
      : super((store, action, next) async {
          next(action);

          /// [databaseService.createConversation] returns a [Future] of either
          /// a [StoreSelectedConversation] or [AddProblem]
          final reaction = await databaseService.createConversation(
              store.state.user.id,
              store.state.newConversationsPage.selectionsVM.selections);
          store.dispatch(reaction);

          // if there was no problem, navigate to Conversation Page
          if (reaction.runtimeType != AddProblem) {
            store.dispatch(NavigatorReplaceCurrent(
                (b) => b..newLocation = '/conversation'));
          }
        });
}
