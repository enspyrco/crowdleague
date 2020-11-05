import 'package:crowdleague/actions/conversations/update_new_conversation_page.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

/// The [UpdateNewConversationPage] action has either the state or a selection.
/// We check which one it is and update the app state accordingly
class UpdateNewConversationPageReducer
    extends TypedReducer<AppState, UpdateNewConversationPage> {
  UpdateNewConversationPageReducer()
      : super((state, action) => (action.selection != null)
            ? state.rebuild((b) => b
              ..newConversationPage.selections.leaguers.add(action.selection)
              ..newConversationPage
                  .suggestions
                  .leaguers
                  .remove(action.selection))
            : state.rebuild((b) => b
              ..newConversationPage
                  .suggestions
                  .leaguers
                  .replace(action.suggestions)));
}
