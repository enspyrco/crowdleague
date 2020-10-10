library other_auth_options_page_data;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/navigation/page_data/page_data.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'other_auth_options_page_data.g.dart';

abstract class OtherAuthOptionsPageData extends Object
    with ReduxAction
    implements
        PageData,
        Built<OtherAuthOptionsPageData, OtherAuthOptionsPageDataBuilder> {
  OtherAuthOptionsPageData._();

  factory OtherAuthOptionsPageData() = _$OtherAuthOptionsPageData._;

  Object toJson() =>
      serializers.serializeWith(OtherAuthOptionsPageData.serializer, this);

  static OtherAuthOptionsPageData fromJson(String jsonString) =>
      serializers.deserializeWith(
          OtherAuthOptionsPageData.serializer, json.decode(jsonString));

  static Serializer<OtherAuthOptionsPageData> get serializer =>
      _$otherAuthOptionsPageDataSerializer;

  @override
  String toString() => 'OTHER_AUTH_OPTIONS_PAGE_DATA';
}
