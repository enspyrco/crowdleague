library navigator_entry;

import 'package:built_value/built_value.dart';

part 'navigator_entry.g.dart';

/// Info on polymorphism with built_value:
/// https://github.com/google/built_value.dart/blob/master/example/lib/polymorphism.dart
@BuiltValue(instantiable: false)
abstract class NavigatorEntry {
  NavigatorEntry rebuild(void Function(NavigatorEntryBuilder) updates);
  NavigatorEntryBuilder toBuilder();
}
