import 'package:crowdleague/actions/navigation/push_page.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class PushPageReducer extends TypedReducer<AppState, PushPage> {
  PushPageReducer()
      : super((state, action) =>
            state.rebuild((b) => b..pagesData.add(action.data)));
}
