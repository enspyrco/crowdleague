import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

typedef Operation = Future<void> Function(Store<AppState> store);

/// An object that can be created with an arbitrary function and will run the
/// function on a given store.
///
/// [StoreOperation] objects can be added to the [ServicesBundle] class and will
/// be used by any [ServicesBundle] object when [createStore()] is called
class StoreOperation {
  final Operation _operation;

  StoreOperation(Operation operation) : _operation = operation;

  Future<void> runOn(Store<AppState> store) => _operation(store);
}
