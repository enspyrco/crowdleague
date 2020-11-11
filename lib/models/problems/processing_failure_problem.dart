library processing_failure_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:crowdleague/models/problems/problem.dart';
import 'package:built_value/serializer.dart';

part 'processing_failure_problem.g.dart';

abstract class ProcessingFailureProblem implements Problem, Built<ProcessingFailureProblem, ProcessingFailureProblemBuilder> {

  ProcessingFailureProblem._();

  factory ProcessingFailureProblem.by([void Function(ProcessingFailureProblemBuilder) updates]) = _$ProcessingFailureProblem;

  Object toJson() =>
    serializers.serializeWith(ProcessingFailureProblem.serializer, this);


  static ProcessingFailureProblem fromJson(String jsonString) =>
    serializers.deserializeWith(ProcessingFailureProblem.serializer, json.decode(jsonString));

  static Serializer<ProcessingFailureProblem> get serializer => _$processingFailureProblemSerializer;
}