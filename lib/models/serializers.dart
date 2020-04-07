import 'package:built_collection/built_collection.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:crowdleague/models/app_state.dart';
import 'package:crowdleague/models/problem.dart';
import 'package:crowdleague/models/provider_info.dart';
import 'package:crowdleague/models/user.dart';

part 'serializers.g.dart';

/// Once per app, define a top level "Serializer" to gather together
/// all the generated serializers.
///
/// Collection of generated serializers for the CrowdLeague app
@SerializersFor([
  Problem,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..add(Iso8601DateTimeSerializer()))
    .build();
