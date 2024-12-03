import 'dart:async';

import 'package:crowdleague/services/firestore_service.dart';
import 'package:crowdleague/venues/models/new_venue.dart';

import '../utils/locator.dart';
import '../venues/models/venue.dart';

class VenuesService {
  var _newVenue = NewVenue();

  final _newVenueStreamController = StreamController<NewVenue>.broadcast();
  Stream<NewVenue> get newVenueStream => _newVenueStreamController.stream;

  /// Create a new venue at the given location, for eventually saving to the db.
  void createNewVenue({required (double, double) at}) {
    _newVenue = NewVenue(latLng: at);
    _newVenueStreamController.add(_newVenue);
  }

  /// Update the members of the new venue before it is saved to the db.
  void updateNewVenue({
    int? type,
    int? facing,
    String? name,
    (double, double)? latLng,
  }) {
    if (type != null) {
      _newVenue.type = type;
    }
    if (facing != null) {
      _newVenue.facing = facing;
    }
    if (name != null) {
      _newVenue.name = name;
    }
    if (latLng != null) {
      _newVenue.latLng = latLng;
    }
    _newVenueStreamController.add(_newVenue);
  }

  /// Returns a Future with the Database Id of the new venue
  Future<String> addNewVenueToDB() {
    return locate<FirestoreService>()
        .addDoc(collectionPath: 'venues', data: _newVenue.toJson());
  }

  Future<void> updateVenue(
      {required String id, required Map<String, Object?> data}) {
    return locate<FirestoreService>().updateDoc(path: 'venues/$id', data: data);
  }

  Future<Set<Venue>> retrieveVenues() async {
    final json =
        await locate<FirestoreService>().getDocs(inCollectionPath: 'venues');
    return json.map<Venue>((json) {
      return Venue.fromJson(json);
    }).toSet();
  }
}
