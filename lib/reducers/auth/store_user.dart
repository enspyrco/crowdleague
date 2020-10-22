import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/actions/auth/store_user.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/navigation/page_data/initial_page_data.dart';
import 'package:crowdleague/models/navigation/page_data/page_data.dart';
import 'package:redux/redux.dart';

/// Updates state with new user
///
/// We reset the pagesData list in order to pop anything on top of the main page
/// (eg. when user has just signed in)
class StoreUserReducer extends TypedReducer<AppState, StoreUser> {
  StoreUserReducer()
      : super((state, action) => state.rebuild((b) => b
          ..user = action.user.toBuilder()
          ..pagesData = ListBuilder<PageData>(<PageData>[InitialPageData()])));
}
