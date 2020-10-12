import 'package:crowdleague/actions/navigation/remove_current_page.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class RemoveCurrentPageReducer
    extends TypedReducer<AppState, RemoveCurrentPage> {
  RemoveCurrentPageReducer()
      : super(
            (state, action) => state.rebuild((b) => b..pagesData.removeLast()));
}
