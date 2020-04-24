import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/models/provider_info.dart';
import 'package:crowdleague/models/user.dart';

final mockProviderInfo = ProviderInfo((b) => b
  ..displayName = 'name'
  ..providerId = 'provider'
  ..photoUrl = 'url'
  ..email = 'email'
  ..uid = 'uid');

final mockUser = User((a) => a
  ..email = 'email'
  ..uid = 'id'
  ..displayName = 'name'
  ..photoUrl = 'url'
  ..providers = ListBuilder([mockProviderInfo]));