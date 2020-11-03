import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/models/auth/provider_info.dart';
import 'package:crowdleague/models/auth/user.dart';

// Create a user object for use in tests.
User get bobUser => User(
    id: '1234',
    displayName: 'bob',
    photoURL: 'photo.com',
    email: 'test@email.com',
    providers: BuiltList<ProviderInfo>());
