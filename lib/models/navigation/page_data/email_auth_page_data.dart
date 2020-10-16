library email_auth_page_data;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/navigation/page_data/page_data.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'email_auth_page_data.g.dart';

abstract class EmailAuthPageData
    implements PageData, Built<EmailAuthPageData, EmailAuthPageDataBuilder> {
  EmailAuthPageData._();

  factory EmailAuthPageData() = _$EmailAuthPageData._;

  Object toJson() =>
      serializers.serializeWith(EmailAuthPageData.serializer, this);

  static EmailAuthPageData fromJson(String jsonString) => serializers
      .deserializeWith(EmailAuthPageData.serializer, json.decode(jsonString));

  static Serializer<EmailAuthPageData> get serializer =>
      _$emailAuthPageDataSerializer;
}
