library upload_error;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'upload_error.g.dart';

abstract class UploadError implements Built<UploadError, UploadErrorBuilder> {
  int get code;
  String get description;

  UploadError._();

  factory UploadError([void Function(UploadErrorBuilder) updates]) =
      _$UploadError;

  Object toJson() => serializers.serializeWith(UploadError.serializer, this);

  static UploadError fromJson(String jsonString) => serializers.deserializeWith(
      UploadError.serializer, json.decode(jsonString));

  static Serializer<UploadError> get serializer => _$uploadErrorSerializer;
}
