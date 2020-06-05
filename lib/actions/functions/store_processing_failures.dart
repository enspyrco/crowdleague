library store_processing_failures;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';
import 'package:crowdleague/models/functions/processing_failure.dart';

part 'store_processing_failures.g.dart';

abstract class StoreProcessingFailures extends Object
    with ReduxAction
    implements Built<StoreProcessingFailures, StoreProcessingFailuresBuilder> {
  BuiltList<ProcessingFailure> get failures;

  StoreProcessingFailures._();

  factory StoreProcessingFailures(
          [void Function(StoreProcessingFailuresBuilder) updates]) =
      _$StoreProcessingFailures;

  Object toJson() =>
      serializers.serializeWith(StoreProcessingFailures.serializer, this);

  static StoreProcessingFailures fromJson(String jsonString) =>
      serializers.deserializeWith(
          StoreProcessingFailures.serializer, json.decode(jsonString));

  static Serializer<StoreProcessingFailures> get serializer =>
      _$storeProcessingFailuresSerializer;

  @override
  String toString() => 'STORE_PROCESSING_FAILURES';
}
