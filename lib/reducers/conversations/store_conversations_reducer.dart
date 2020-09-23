import 'package:crowdleague/actions/conversations/store_conversations.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class StoreConversationsReducer
    extends TypedReducer<AppState, StoreConversations> {
  StoreConversationsReducer()
      : super((state, action) => state.rebuild((b) =>
            b..conversationSummariesPage.summaries.replace(action.summaries)));
}
