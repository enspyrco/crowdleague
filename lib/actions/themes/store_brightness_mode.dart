library store_brightness_mode;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/enums/themes/brightness_mode.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'store_brightness_mode.g.dart';

abstract class StoreBrightnessMode extends Object
    with ReduxAction
    implements Built<StoreBrightnessMode, StoreBrightnessModeBuilder> {
  BrightnessMode get mode;

  StoreBrightnessMode._();

  factory StoreBrightnessMode(
          [void Function(StoreBrightnessModeBuilder) updates]) =
      _$StoreBrightnessMode;

  Object toJson() =>
      serializers.serializeWith(StoreBrightnessMode.serializer, this);

  static StoreBrightnessMode fromJson(String jsonString) => serializers
      .deserializeWith(StoreBrightnessMode.serializer, json.decode(jsonString));

  static Serializer<StoreBrightnessMode> get serializer =>
      _$storeBrightnessModeSerializer;

  @override
  String toString() => 'STORE_BRIGHTNESS_MODE';
}
