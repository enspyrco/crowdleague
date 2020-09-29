library system_info;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'system_info.g.dart';

abstract class SystemInfo implements Built<SystemInfo, SystemInfoBuilder> {
  PlatformType get platform;

  SystemInfo._();

  factory SystemInfo({@required PlatformType platform}) = _$SystemInfo._;

  factory SystemInfo.by([void Function(SystemInfoBuilder) updates]) =
      _$SystemInfo;

  Object toJson() => serializers.serializeWith(SystemInfo.serializer, this);

  static SystemInfo fromJson(String jsonString) => serializers.deserializeWith(
      SystemInfo.serializer, json.decode(jsonString));

  static Serializer<SystemInfo> get serializer => _$systemInfoSerializer;
}
