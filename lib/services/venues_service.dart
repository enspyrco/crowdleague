import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:crowdleague/services/storage_service.dart';
import 'package:crowdleague/venues/models/upload_event.dart';
import 'package:rxdart/subjects.dart';

import '../utils/api_keys.dart';
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

  /// Create a new venue at the given location and return the id
  Future<String> createNewVenue() async {
    return locate<FirestoreService>()
        .addDoc(collectionPath: 'venues', data: _localVenue.toJson());
  }

  Future<String> getDownloadUrl(String storagePath) {
    return locate<StorageService>().getDownLoadUrl(storagePath: storagePath);
  }

  Stream<UploadEvent> uploadIconBytes({required String storagePath}) {
    return locate<StorageService>()
        .uploadBytes(bytes: _localVenue.iconBytes!, storagePath: storagePath);
  }

  Stream<UploadEvent> uploadFile({required String storagePath}) {
    return locate<StorageService>().uploadFile(
        localPath: _localVenue.largePhotoPath!, storagePath: storagePath);
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

  Future<String> retrieveAddress(String latitude, String longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$reverseGeocodingApiKey');
    // Make the API call
    final response = await http.get(url);

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Check if results exist
      if (jsonResponse['status'] == 'OK' && jsonResponse['results'] != null) {
        // Take the first result (most specific location)
        final firstResult = jsonResponse['results'][0];
        final formattedAdress = firstResult['formatted_address'] as String?;
        if (formattedAdress == null) {
          throw Exception('Formatted address was null');
        }
        return formattedAdress;
      } else {
        throw Exception('No results found or API returned an error');
      }
    } else {
      throw Exception('Failed to load geocoding data');
    }
  }
}
