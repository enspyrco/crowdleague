import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/models/auth/provider_info.dart';
import 'package:crowdleague/models/auth/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

extension Convert on auth.User {
  // return a User with fields from the auth.User or null
  User toUser() => User(
        id: uid,
        displayName: displayName ?? 'No name',
        email: email ?? 'noemail',
        photoURL: photoURL ?? 'default',
        providers: (providerData == null)
            ? BuiltList(<ProviderInfo>[])
            : BuiltList(providerData
                .map<ProviderInfo>((userInfo) => userInfo.toProviderInfo())),
      );
}

extension ConvertUserInfo on auth.UserInfo {
  ProviderInfo toProviderInfo() => ProviderInfo(
      displayName: displayName,
      email: email,
      phoneNumber: phoneNumber,
      photoURL: photoURL,
      providerId: providerId,
      uid: uid);
}
