library request_fcm_permissions;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'request_fcm_permissions.g.dart';

abstract class RequestFCMPermissions extends Object
    with ReduxAction
    implements Built<RequestFCMPermissions, RequestFCMPermissionsBuilder> {
  RequestFCMPermissions._();

  factory RequestFCMPermissions(
          [void Function(RequestFCMPermissionsBuilder) updates]) =
      _$RequestFCMPermissions;

  Object toJson() =>
      serializers.serializeWith(RequestFCMPermissions.serializer, this);

  static RequestFCMPermissions fromJson(String jsonString) =>
      serializers.deserializeWith(
          RequestFCMPermissions.serializer, json.decode(jsonString));

  static Serializer<RequestFCMPermissions> get serializer =>
      _$requestFCMPermissionsSerializer;

  @override
  String toString() => 'REQUEST_FCM_PERMISSIONS';
}
