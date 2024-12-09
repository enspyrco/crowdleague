import 'dart:async';

import 'package:crowdleague/services/firestore_service.dart';
import 'package:crowdleague/venues/models/new_venue.dart';
import 'package:rxdart/subjects.dart';

import '../utils/locator.dart';
import '../venues/models/venue.dart';

class VenuesService {
  var _newVenue = NewVenue();

  final _newVenueSubject = BehaviorSubject<NewVenue>.seeded(NewVenue());

  Stream<NewVenue> get newVenueStream => _newVenueSubject.stream;

  /// Create a new venue at the given location, for eventually saving to the db.
  void createNewVenue({required (double, double) at}) {
    _newVenue = NewVenue(latLng: at);
    _newVenueSubject.add(_newVenue);
  }

  /// Update the members of the new venue before it is saved to the db.
  void updateNewVenue({
    int? size,
    int? surface,
    int? environment,
    String? name,
    String? address,
    (double, double)? latLng,
    String? iconUrl,
    String? largePhotoUrl,
  }) {
    if (size != null) {
      _newVenue.size = size;
    }
    if (surface != null) {
      _newVenue.surface = surface;
    }
    if (environment != null) {
      _newVenue.environment = environment;
    }
    if (name != null) {
      _newVenue.name = name;
    }
    if (address != null) {
      _newVenue.address = address;
    }
    if (latLng != null) {
      _newVenue.latLng = latLng;
    }
    if (iconUrl != null) {
      _newVenue.iconUrl = iconUrl;
    }
    if (largePhotoUrl != null) {
      _newVenue.largePhotoUrl = largePhotoUrl;
    }
    _newVenueSubject.add(_newVenue);
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

  Future<Venue?> retrieveVenue(String id) async {
    final json = await locate<FirestoreService>().getDoc(atPath: 'venues/$id');
    if (json == null) return null;
    return Venue.fromJson(json);
  }
}
