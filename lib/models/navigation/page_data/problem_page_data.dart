library problem_page_data;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/navigation/page_data/page_data.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'problem_page_data.g.dart';

abstract class ProblemPageData
    implements PageData, Built<ProblemPageData, ProblemPageDataBuilder> {
  ProblemBase get problem;

  ProblemPageData._();

  factory ProblemPageData({@required ProblemBase problem}) =
      _$ProblemPageData._;

  Object toJson() =>
      serializers.serializeWith(ProblemPageData.serializer, this);

  static ProblemPageData fromJson(String jsonString) => serializers
      .deserializeWith(ProblemPageData.serializer, json.decode(jsonString));

  static Serializer<ProblemPageData> get serializer =>
      _$problemPageDataSerializer;
}
