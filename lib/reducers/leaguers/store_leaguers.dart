import 'package:crowdleague/actions/leaguers/store_leaguers.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class StoreLeaguersReducer extends TypedReducer<AppState, StoreLeaguers> {
  StoreLeaguersReducer()
      : super((state, action) => state.rebuild((b) => b
          ..newConversationPage.leaguersVM.leaguers.replace(action.leaguers)));
}
