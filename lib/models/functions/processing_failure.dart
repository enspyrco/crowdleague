library processing_failure;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/enums/processing_failure_type.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'processing_failure.g.dart';

abstract class ProcessingFailure
    implements Built<ProcessingFailure, ProcessingFailureBuilder> {
  ProcessingFailure._();
  String get id;
  bool get seen;
  ProcessingFailureType get type;
  DateTime get createdOn;
  Object get data;
  String get message;

  factory ProcessingFailure([void Function(ProcessingFailureBuilder) updates]) =
      _$ProcessingFailure;

  Object toJson() =>
      serializers.serializeWith(ProcessingFailure.serializer, this);

  static ProcessingFailure fromJson(String jsonString) => serializers
      .deserializeWith(ProcessingFailure.serializer, json.decode(jsonString));

  static Serializer<ProcessingFailure> get serializer =>
      _$processingFailureSerializer;
}
