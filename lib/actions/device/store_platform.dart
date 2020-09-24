library store_platform;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:crowdleague/models/app/serializers.dart';
import 'package:meta/meta.dart';

part 'store_platform.g.dart';

abstract class StorePlatform extends Object
    with ReduxAction
    implements Built<StorePlatform, StorePlatformBuilder> {
  PlatformType get value;

  StorePlatform._();

  factory StorePlatform({@required PlatformType value}) = _$StorePlatform._;

  factory StorePlatform.by([void Function(StorePlatformBuilder) updates]) =
      _$StorePlatform;

  Object toJson() => serializers.serializeWith(StorePlatform.serializer, this);

  static StorePlatform fromJson(String jsonString) => serializers
      .deserializeWith(StorePlatform.serializer, json.decode(jsonString));

  static Serializer<StorePlatform> get serializer => _$storePlatformSerializer;

  @override
  String toString() => 'STORE_PLATFORM';
}
