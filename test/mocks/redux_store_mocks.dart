import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';

class FakeStore extends Fake implements Store<AppState> {
  @override
  dynamic dispatch(dynamic action) {
    return ReduxAction;
  }
}
