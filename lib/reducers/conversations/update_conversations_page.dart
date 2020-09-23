import 'package:crowdleague/actions/conversations/update_conversation_page.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class UpdateConversationPageReducer
    extends TypedReducer<AppState, UpdateConversationPage> {
  UpdateConversationPageReducer()
      : super((state, action) => state.rebuild(
            (b) => b..conversationPage.messageText = action.messageText));
}
