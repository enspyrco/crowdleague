library user;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/auth/provider_info.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'user.g.dart';

/// Non-null Strings: [uid], [displayName], [photoURL], [email]
/// A list of [ProviderInfo]: providers
abstract class User implements Built<User, UserBuilder> {
  /// The uid of the user's Firebase account.
  String get id;

  /// The name of the user.
  String get displayName;

  /// The URL of the user’s profile photo.
  String get photoURL;

  /// The user’s email address.
  String get email;

  /// Info on each auth provider the user has linked to their account.
  BuiltList<ProviderInfo> get providers;

  User._();

  factory User(
      {@required String id,
      @required String displayName,
      @required String photoURL,
      @required String email,
      @required BuiltList<ProviderInfo> providers}) = _$User._;

  factory User.by([void Function(UserBuilder) updates]) = _$User;

  Object toJson() => serializers.serializeWith(User.serializer, this);

  static User fromJson(String jsonString) =>
      serializers.deserializeWith(User.serializer, json.decode(jsonString));

  static Serializer<User> get serializer => _$userSerializer;
}
