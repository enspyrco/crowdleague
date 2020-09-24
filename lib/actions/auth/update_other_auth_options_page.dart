library update_other_auth_options_page;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/enums/email_auth_mode.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'update_other_auth_options_page.g.dart';

abstract class UpdateOtherAuthOptionsPage extends Object
    with ReduxAction
    implements
        Built<UpdateOtherAuthOptionsPage, UpdateOtherAuthOptionsPageBuilder> {
  @nullable
  EmailAuthMode get mode;
  @nullable
  AuthStep get step;
  @nullable
  bool get showPassword;
  @nullable
  String get email;
  @nullable
  String get password;
  @nullable
  String get repeatPassword;

  UpdateOtherAuthOptionsPage._();

  factory UpdateOtherAuthOptionsPage(
          [void Function(UpdateOtherAuthOptionsPageBuilder) updates]) =
      _$UpdateOtherAuthOptionsPage;

  Object toJson() =>
      serializers.serializeWith(UpdateOtherAuthOptionsPage.serializer, this);

  static UpdateOtherAuthOptionsPage fromJson(String jsonString) =>
      serializers.deserializeWith(
          UpdateOtherAuthOptionsPage.serializer, json.decode(jsonString));

  static Serializer<UpdateOtherAuthOptionsPage> get serializer =>
      _$updateOtherAuthOptionsPageSerializer;

  @override
  String toString() => 'UPDATE_OTHER_AUTH_OPTIONS_PAGE';
}
