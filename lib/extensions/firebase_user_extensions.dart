import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/models/auth/provider_info.dart';
import 'package:crowdleague/models/auth/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension Convert on FirebaseUser {
  // return a User with fields from the FirebaseUser or null
  User toUser() {
    return User(
      (b) => b
        ..uid = uid
        ..displayName = displayName ?? 'No name'
        ..email = email ?? 'noemail'
        ..photoUrl = photoUrl ?? 'default'
        ..providers = (providerData == null)
            ? ListBuilder()
            : ListBuilder(
                providerData.map<ProviderInfo>(
                  (provider) => ProviderInfo((b) => b
                    ..displayName = provider.displayName
                    ..email = provider.email
                    ..phoneNumber = provider.phoneNumber
                    ..photoUrl = provider.photoUrl
                    ..providerId = provider.providerId
                    ..uid = provider.uid),
                ),
              ),
    );
  }
}
