library vm_profile_page;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/app/serializers.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';

part 'vm_profile_page.g.dart';

abstract class VmProfilePage
    implements Built<VmProfilePage, VmProfilePageBuilder> {
  @nullable
  Leaguer get leaguer;

  VmProfilePage._();

  factory VmProfilePage([void Function(VmProfilePageBuilder) updates]) =
      _$VmProfilePage;

  Object toJson() => serializers.serializeWith(VmProfilePage.serializer, this);

  static VmProfilePage fromJson(String jsonString) => serializers
      .deserializeWith(VmProfilePage.serializer, json.decode(jsonString));

  static Serializer<VmProfilePage> get serializer => _$vmProfilePageSerializer;
}
