import 'package:crowdleague/actions/navigation/remove_current_page.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

/// Remove the current page from the stack, unless the stack is only one page
class RemoveCurrentPageReducer
    extends TypedReducer<AppState, RemoveCurrentPage> {
  RemoveCurrentPageReducer()
      : super((state, action) => (state.pagesData.length > 1)
            ? state.rebuild((b) => b..pagesData.removeLast())
            : state);
}
