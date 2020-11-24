library delete_profile_pic_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:built_value/serializer.dart';

part 'delete_profile_pic_problem.g.dart';

abstract class DeleteProfilePicProblem implements ProblemBase, Built<DeleteProfilePicProblem, DeleteProfilePicProblemBuilder> {

  DeleteProfilePicProblem._();

  factory DeleteProfilePicProblem.by([void Function(DeleteProfilePicProblemBuilder) updates]) = _$DeleteProfilePicProblem;

  Object toJson() =>
    serializers.serializeWith(DeleteProfilePicProblem.serializer, this);


  static DeleteProfilePicProblem fromJson(String jsonString) =>
    serializers.deserializeWith(DeleteProfilePicProblem.serializer, json.decode(jsonString));

  static Serializer<DeleteProfilePicProblem> get serializer => _$deleteProfilePicProblemSerializer;
}