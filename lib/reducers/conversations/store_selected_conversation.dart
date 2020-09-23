import 'package:crowdleague/actions/conversations/store_selected_conversation.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class StoreSelectedConversationReducer
    extends TypedReducer<AppState, StoreSelectedConversation> {
  StoreSelectedConversationReducer()
      : super((state, action) => state.rebuild(
            (b) => b..conversationPage.summary.replace(action.summary)));
}
