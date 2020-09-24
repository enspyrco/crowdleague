library acknowledge_processing_failure;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'acknowledge_processing_failure.g.dart';

abstract class AcknowledgeProcessingFailure extends Object
    with
        ReduxAction
    implements
        Built<AcknowledgeProcessingFailure,
            AcknowledgeProcessingFailureBuilder> {
  String get id;

  AcknowledgeProcessingFailure._();

  factory AcknowledgeProcessingFailure(
          [void Function(AcknowledgeProcessingFailureBuilder) updates]) =
      _$AcknowledgeProcessingFailure;

  Object toJson() =>
      serializers.serializeWith(AcknowledgeProcessingFailure.serializer, this);

  static AcknowledgeProcessingFailure fromJson(String jsonString) =>
      serializers.deserializeWith(
          AcknowledgeProcessingFailure.serializer, json.decode(jsonString));

  static Serializer<AcknowledgeProcessingFailure> get serializer =>
      _$acknowledgeProcessingFailureSerializer;

  @override
  String toString() => 'ACKNOWLEDGE_PROCESSING_FAILURE';
}
