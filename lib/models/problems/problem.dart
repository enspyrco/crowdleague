library problem;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'problem.g.dart';

@BuiltValue(instantiable: false)
abstract class Problem {
  String get message;
  String get trace;
  BuiltMap<dynamic, dynamic> get info;
  @nullable
  Problem rebuild(void Function(ProblemBuilder) updates);
  ProblemBuilder toBuilder();
}
