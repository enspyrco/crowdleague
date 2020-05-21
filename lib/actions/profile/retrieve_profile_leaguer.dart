library retrieve_profile_leaguer;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'retrieve_profile_leaguer.g.dart';

abstract class RetrieveProfileLeaguer extends Object
    with ReduxAction
    implements Built<RetrieveProfileLeaguer, RetrieveProfileLeaguerBuilder> {
  RetrieveProfileLeaguer._();

  factory RetrieveProfileLeaguer(
          [void Function(RetrieveProfileLeaguerBuilder) updates]) =
      _$RetrieveProfileLeaguer;

  Object toJson() =>
      serializers.serializeWith(RetrieveProfileLeaguer.serializer, this);

  static RetrieveProfileLeaguer fromJson(String jsonString) =>
      serializers.deserializeWith(
          RetrieveProfileLeaguer.serializer, json.decode(jsonString));

  static Serializer<RetrieveProfileLeaguer> get serializer =>
      _$retrieveProfileLeaguerSerializer;

  @override
  String toString() => 'RETRIEVE_PROFILE_LEAGUER';
}
