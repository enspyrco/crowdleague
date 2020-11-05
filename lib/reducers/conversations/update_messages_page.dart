import 'package:crowdleague/actions/conversations/update_messages_page.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class UpdateMessagesPageReducer
    extends TypedReducer<AppState, UpdateMessagesPage> {
  UpdateMessagesPageReducer()
      : super((state, action) => state
            .rebuild((b) => b..messagesPage.messageText = action.messageText));
}
