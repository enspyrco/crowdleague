import 'package:crowdleague/actions/conversations/store_messages.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class StoreMessagesReducer extends TypedReducer<AppState, StoreMessages> {
  StoreMessagesReducer()
      : super((state, action) => state.rebuild(
            (b) => b..conversationPage.messages.replace(action.messages)));
}
