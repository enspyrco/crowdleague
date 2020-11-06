library problem;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'problem.g.dart';

@BuiltValue(instantiable: false)
abstract class Problem {
  String get message;
  BuiltMap<String, Object> get info;
  @nullable
  String get trace;

  Problem rebuild(void Function(ProblemBuilder) updates);
  ProblemBuilder toBuilder();
}
