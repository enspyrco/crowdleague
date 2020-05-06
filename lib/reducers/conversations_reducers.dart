import 'package:crowdleague/models/actions/conversations/update_new_conversation_page.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app/app_state.dart';

/// Reducers specify how the application"s state changes in response to actions
/// sent to the store.
///
/// Each reducer returns a new [AppState].
final conversationsReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, UpdateNewConversationPage>(_updateNewConversationPage),
];

/// The [UpdateNewConversationPage] action has either the state or a selection
/// we check which one it is and update the app state accordingly
AppState _updateNewConversationPage(
    AppState state, UpdateNewConversationPage action) {
  if (action.selection != null) {
    return state.rebuild((b) => b
      ..newConversationsPage.selectionsVM.selections.add(action.selection)
      ..newConversationsPage.leaguersVM.leaguers.remove(action.selection));
  } else {
    return state.rebuild(
        (b) => b..newConversationsPage.leaguersVM.state = action.state);
  }
}
