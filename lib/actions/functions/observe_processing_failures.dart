library observe_processing_failures;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'observe_processing_failures.g.dart';

abstract class ObserveProcessingFailures extends Object
    with ReduxAction
    implements
        Built<ObserveProcessingFailures, ObserveProcessingFailuresBuilder> {
  ObserveProcessingFailures._();

  factory ObserveProcessingFailures(
          [void Function(ObserveProcessingFailuresBuilder) updates]) =
      _$ObserveProcessingFailures;

  Object toJson() =>
      serializers.serializeWith(ObserveProcessingFailures.serializer, this);

  static ObserveProcessingFailures fromJson(String jsonString) =>
      serializers.deserializeWith(
          ObserveProcessingFailures.serializer, json.decode(jsonString));

  static Serializer<ObserveProcessingFailures> get serializer =>
      _$observeProcessingFailuresSerializer;

  @override
  String toString() => 'OBSERVE_PROCESSING_FAILURES';
}
