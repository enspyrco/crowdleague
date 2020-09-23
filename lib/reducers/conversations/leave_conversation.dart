import 'package:crowdleague/actions/conversations/leave_conversation.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class LeaveConversationReducer
    extends TypedReducer<AppState, LeaveConversation> {
  LeaveConversationReducer()
      : super((state, action) => state.rebuild((b) => b
          ..conversationSummariesPage.summaries.removeWhere(
              (summary) => summary.conversationId == action.conversationId)));
}
