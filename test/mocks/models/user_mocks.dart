import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/models/auth/provider_info.dart';
import 'package:crowdleague/models/auth/user.dart';

final mockProviderInfo = ProviderInfo(
    displayName: 'name',
    providerId: 'provider',
    photoURL: 'url',
    email: 'email',
    uid: 'uid');

final mockUser = User(
    email: 'email',
    id: 'id',
    displayName: 'name',
    photoURL: 'url',
    providers: BuiltList(<dynamic>[mockProviderInfo]));
