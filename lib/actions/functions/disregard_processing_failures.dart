library disregard_processing_failures;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'disregard_processing_failures.g.dart';

abstract class DisregardProcessingFailures extends Object
    with ReduxAction
    implements
        Built<DisregardProcessingFailures, DisregardProcessingFailuresBuilder> {
  DisregardProcessingFailures._();

  factory DisregardProcessingFailures(
          [void Function(DisregardProcessingFailuresBuilder) updates]) =
      _$DisregardProcessingFailures;

  Object toJson() =>
      serializers.serializeWith(DisregardProcessingFailures.serializer, this);

  static DisregardProcessingFailures fromJson(String jsonString) =>
      serializers.deserializeWith(
          DisregardProcessingFailures.serializer, json.decode(jsonString));

  static Serializer<DisregardProcessingFailures> get serializer =>
      _$disregardProcessingFailuresSerializer;

  @override
  String toString() => 'DISREGARD_PROCESSING_FAILURES';
}
