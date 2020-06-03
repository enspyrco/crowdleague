import 'package:crowdleague/actions/functions/store_processing_failures.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

final functionsReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, StoreProcessingFailures>(_storeProcessingFailures),
];

AppState _storeProcessingFailures(
    AppState state, StoreProcessingFailures action) {
  return state.rebuild((b) => b..processingFailures.replace(action.failures));
}
