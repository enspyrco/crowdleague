library upload_task_failure_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:built_value/serializer.dart';

part 'upload_task_failure_problem.g.dart';

abstract class UploadTaskFailureProblem implements ProblemBase, Built<UploadTaskFailureProblem, UploadTaskFailureProblemBuilder> {

  UploadTaskFailureProblem._();

  factory UploadTaskFailureProblem.by([void Function(UploadTaskFailureProblemBuilder) updates]) = _$UploadTaskFailureProblem;

  Object toJson() =>
    serializers.serializeWith(UploadTaskFailureProblem.serializer, this);


  static UploadTaskFailureProblem fromJson(String jsonString) =>
    serializers.deserializeWith(UploadTaskFailureProblem.serializer, json.decode(jsonString));

  static Serializer<UploadTaskFailureProblem> get serializer => _$uploadTaskFailureProblemSerializer;
}