library store_auth_step;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/enums/auth/auth_step.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'store_auth_step.g.dart';

abstract class StoreAuthStep extends Object
    with ReduxAction
    implements Built<StoreAuthStep, StoreAuthStepBuilder> {
  AuthStep get step;

  StoreAuthStep._();

  factory StoreAuthStep({@required AuthStep step}) = _$StoreAuthStep._;

  factory StoreAuthStep.by([void Function(StoreAuthStepBuilder) updates]) =
      _$StoreAuthStep;

  Object toJson() => serializers.serializeWith(StoreAuthStep.serializer, this);

  static StoreAuthStep fromJson(String jsonString) => serializers
      .deserializeWith(StoreAuthStep.serializer, json.decode(jsonString));

  static Serializer<StoreAuthStep> get serializer => _$storeAuthStepSerializer;

  @override
  String toString() => 'STORE_AUTH_STEP: $step';
}
