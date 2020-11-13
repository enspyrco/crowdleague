library observe_processing_failures_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:built_value/serializer.dart';

part 'observe_processing_failures_problem.g.dart';

abstract class ObserveProcessingFailuresProblem implements ProblemBase, Built<ObserveProcessingFailuresProblem, ObserveProcessingFailuresProblemBuilder> {

  ObserveProcessingFailuresProblem._();

  factory ObserveProcessingFailuresProblem.by([void Function(ObserveProcessingFailuresProblemBuilder) updates]) = _$ObserveProcessingFailuresProblem;

  Object toJson() =>
    serializers.serializeWith(ObserveProcessingFailuresProblem.serializer, this);


  static ObserveProcessingFailuresProblem fromJson(String jsonString) =>
    serializers.deserializeWith(ObserveProcessingFailuresProblem.serializer, json.decode(jsonString));

  static Serializer<ObserveProcessingFailuresProblem> get serializer => _$observeProcessingFailuresProblemSerializer;
}