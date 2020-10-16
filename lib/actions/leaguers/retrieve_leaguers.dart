library retrieve_leaguers;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'retrieve_leaguers.g.dart';

abstract class RetrieveLeaguers extends Object
    with ReduxAction
    implements Built<RetrieveLeaguers, RetrieveLeaguersBuilder> {
  RetrieveLeaguers._();

  factory RetrieveLeaguers() = _$RetrieveLeaguers;

  Object toJson() =>
      serializers.serializeWith(RetrieveLeaguers.serializer, this);

  static RetrieveLeaguers fromJson(String jsonString) => serializers
      .deserializeWith(RetrieveLeaguers.serializer, json.decode(jsonString));

  static Serializer<RetrieveLeaguers> get serializer =>
      _$retrieveLeaguersSerializer;

  @override
  String toString() => 'RETRIEVE_LEAGUERS';
}
