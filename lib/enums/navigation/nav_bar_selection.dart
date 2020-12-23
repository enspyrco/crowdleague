import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'nav_bar_selection.g.dart';

class NavBarSelection extends EnumClass {
  static const NavBarSelection home = _$home;
  static const NavBarSelection business = _$business;
  static const NavBarSelection venues = _$venues;
  static const NavBarSelection conversations = _$conversations;
  static const NavBarSelection more = _$more;

  const NavBarSelection._(String name) : super(name);

  static final _$indexMap = BuiltMap<NavBarSelection, int>({
    home: 0,
    venues: 1,
    business: 2,
    conversations: 3,
    more: 4,
  });
  int get index => _$indexMap[this];

  static BuiltSet<NavBarSelection> get values => _$values;
  static NavBarSelection valueOf(String name) => _$valueOf(name);
  static NavBarSelection valueOfIndex(int index) {
    switch (index) {
      case 0:
        return _$home;
      case 1:
        return _$venues;
      case 2:
        return _$business;
      case 3:
        return _$conversations;
      case 4:
        return _$more;
      default:
        throw ArgumentError(index);
    }
  }

  static Serializer<NavBarSelection> get serializer =>
      _$navBarSelectionSerializer;

  Object toJson() =>
      serializers.serializeWith(NavBarSelection.serializer, this);
}
