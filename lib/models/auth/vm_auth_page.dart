library vm_auth_page;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/enums/auth_step.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'vm_auth_page.g.dart';

abstract class VmAuthPage implements Built<VmAuthPage, VmAuthPageBuilder> {
  AuthStep get step;

  VmAuthPage._();

  factory VmAuthPage([void Function(VmAuthPageBuilder) updates]) = _$VmAuthPage;

  static VmAuthPageBuilder initBuilder() {
    return VmAuthPageBuilder()..step = AuthStep.waitingForInput;
  }

  Object toJson() => serializers.serializeWith(VmAuthPage.serializer, this);

  static VmAuthPage fromJson(String jsonString) => serializers.deserializeWith(
      VmAuthPage.serializer, json.decode(jsonString));

  static Serializer<VmAuthPage> get serializer => _$vmAuthPageSerializer;
}
