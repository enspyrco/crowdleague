library update_processing_failure;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'update_processing_failure.g.dart';

abstract class UpdateProcessingFailure extends Object
    with ReduxAction
    implements Built<UpdateProcessingFailure, UpdateProcessingFailureBuilder> {
  bool get seen;

  UpdateProcessingFailure._();

  factory UpdateProcessingFailure(
          [void Function(UpdateProcessingFailureBuilder) updates]) =
      _$UpdateProcessingFailure;

  Object toJson() =>
      serializers.serializeWith(UpdateProcessingFailure.serializer, this);

  static UpdateProcessingFailure fromJson(String jsonString) =>
      serializers.deserializeWith(
          UpdateProcessingFailure.serializer, json.decode(jsonString));

  static Serializer<UpdateProcessingFailure> get serializer =>
      _$updateProcessingFailureSerializer;

  @override
  String toString() => 'UPDATE_PROCESSING_FAILURE';
}
