import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/models/provider_info.dart';
import 'package:crowdleague/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension Convert on FirebaseUser {
  // return a User with fields from the FirebaseUser or null
  User toUser() {
    return User(
      (b) => b
        ..uid = this.uid
        ..displayName = this.displayName ?? 'No name'
        ..email = this.email ?? 'noemail'
        ..photoUrl = this.photoUrl ?? 'default'
        ..providers = (this.providerData == null)
            ? ListBuilder()
            : ListBuilder(
                this.providerData.map<ProviderInfo>(
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
