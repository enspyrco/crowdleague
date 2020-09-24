library check_platform;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'check_platform.g.dart';

/// A [ReduxAction] that is dispatched on app load that so the [DeviceService]
/// can be used to retrieve the [PlatformType]
abstract class CheckPlatform extends Object
    with ReduxAction
    implements Built<CheckPlatform, CheckPlatformBuilder> {
  CheckPlatform._();

  factory CheckPlatform() = _$CheckPlatform._;

  factory CheckPlatform.by([void Function(CheckPlatformBuilder) updates]) =
      _$CheckPlatform;

  Object toJson() => serializers.serializeWith(CheckPlatform.serializer, this);

  static CheckPlatform fromJson(String jsonString) => serializers
      .deserializeWith(CheckPlatform.serializer, json.decode(jsonString));

  static Serializer<CheckPlatform> get serializer => _$checkPlatformSerializer;

  @override
  String toString() => 'CHECK_PLATFORM';
}
