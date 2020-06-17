library upload_failure;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'upload_failure.g.dart';

abstract class UploadFailure
    implements Built<UploadFailure, UploadFailureBuilder> {
  int get code;
  String get description;

  UploadFailure._();

  factory UploadFailure([void Function(UploadFailureBuilder) updates]) =
      _$UploadFailure;

  Object toJson() => serializers.serializeWith(UploadFailure.serializer, this);

  static UploadFailure fromJson(String jsonString) => serializers
      .deserializeWith(UploadFailure.serializer, json.decode(jsonString));

  static Serializer<UploadFailure> get serializer => _$uploadFailureSerializer;
}
