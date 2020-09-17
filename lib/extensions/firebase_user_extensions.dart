import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/models/auth/provider_info.dart';
import 'package:crowdleague/models/auth/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

extension Convert on auth.User {
  // return a User with fields from the auth.User or null
  User toUser() {
    return User(
      (b) => b
        ..id = uid
        ..displayName = displayName ?? 'No name'
        ..email = email ?? 'noemail'
        ..photoURL = photoURL ?? 'default'
        ..providers = (providerData == null)
            ? ListBuilder()
            : ListBuilder(
                providerData.map<ProviderInfo>(
                  (provider) => ProviderInfo((b) => b
                    ..displayName = provider.displayName
                    ..email = provider.email
                    ..phoneNumber = provider.phoneNumber
                    ..photoURL = provider.photoURL
                    ..providerId = provider.providerId
                    ..uid = provider.uid),
                ),
              ),
    );
  }
}
