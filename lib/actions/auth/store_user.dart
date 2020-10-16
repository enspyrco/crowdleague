library store_user;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/auth/user.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'store_user.g.dart';

abstract class StoreUser extends Object
    with ReduxAction
    implements Built<StoreUser, StoreUserBuilder> {
  User get user;

  StoreUser._();

  factory StoreUser({@required User user}) = _$StoreUser._;

  factory StoreUser.by([void Function(StoreUserBuilder) updates]) = _$StoreUser;

  Object toJson() => serializers.serializeWith(StoreUser.serializer, this);

  static StoreUser fromJson(String jsonString) => serializers.deserializeWith(
      StoreUser.serializer, json.decode(jsonString));

  static Serializer<StoreUser> get serializer => _$storeUserSerializer;

  @override
  String toString() => 'STORE_USER';
}
