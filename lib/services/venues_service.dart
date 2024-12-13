import 'dart:async';
import 'dart:typed_data';

import 'package:crowdleague/services/storage_service.dart';
import 'package:rxdart/subjects.dart';

import '../utils/locator.dart';
import '../venues/models/local_venue.dart';
import '../venues/models/venue.dart';
import 'firestore_service.dart';

class VenuesService {
  /// A local copy of the venue for local state that we can listen to, in order
  /// to update the UI when certain values change, eg. multi-venue has no
  /// surface value.
  final _localVenue = LocalVenue();

  final _localVenueSubject = BehaviorSubject<LocalVenue>.seeded(LocalVenue());
  Stream<LocalVenue> get localVenueStream => _localVenueSubject.stream;

  final _uploadProgressSubject = BehaviorSubject<int>.seeded(0);
  Stream<int> get uploadProgressStream => _uploadProgressSubject.stream;

  /// Create a new venue at the given location, with photos if one was picked
  Future<void> createNewVenue() async {
    final venueId = await locate<FirestoreService>()
        .addDoc(collectionPath: 'venues', data: _localVenue.toJson());

    // Upload icon bytes
    if (_localVenue.largePhotoPath != null) {
      // if the user has picked a photo
      final iconUrl = await locate<StorageService>().uploadBytes(
          bytes: _localVenue.iconBytes!,
          storagePath: 'venuePhotos/${venueId}_icon');

      final storagePath = 'venuePhotos/${venueId}_large';

      //  Upload large photo file
      await for (final _ in locate<StorageService>().uploadFile(
        localPath: _localVenue.largePhotoPath!,
        storagePath: storagePath,
      )) {}

      final largePhotoUrl = await locate<StorageService>()
          .getDownLoadUrl(storagePath: storagePath);

      // add photo Urls to data
      await locate<FirestoreService>().updateDoc(
        path: 'venues/$venueId',
        data: {'largePhotoUrl': largePhotoUrl, 'iconUrl': iconUrl},
      );
    }
  }

  /// Update the members of the new venue before it is saved to the db.
  void updateLocalVenue({
    int? size,
    int? surface,
    int? environment,
    String? name,
    String? address,
    (double, double)? latLng,
    Uint8List? iconBytes,
    String? largePhotoPath,
  }) {
    if (size != null) {
      _localVenue.size = size;
    }
    if (surface != null) {
      _localVenue.surface = surface;
    }
    if (environment != null) {
      _localVenue.environment = environment;
    }
    if (name != null) {
      _localVenue.name = name;
    }
    if (address != null) {
      _localVenue.address = address;
    }
    if (latLng != null) {
      _localVenue.latitude = latLng.$1;
      _localVenue.longitude = latLng.$2;
    }
    if (iconBytes != null) {
      _localVenue.iconBytes = iconBytes;
    }
    if (largePhotoPath != null) {
      _localVenue.largePhotoPath = largePhotoPath;
    }

    _localVenueSubject.add(_localVenue);
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

  Future<void> deleteVenue({required Venue venue}) async {
    await locate<StorageService>().deleteFile(
      'venuePhotos',
      '${venue.id}_large',
    );
    await locate<StorageService>().deleteFile(
      'venuePhotos',
      '${venue.id}_icon',
    );
    await locate<FirestoreService>().deleteDoc(atPath: 'venues/${venue.id}');
  }
}
