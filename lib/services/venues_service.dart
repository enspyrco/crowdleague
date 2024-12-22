import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:crowdleague/services/storage_service.dart';
import 'package:crowdleague/venues/models/upload_event.dart';
import 'package:rxdart/subjects.dart';

import '../utils/api_keys.dart';
import '../utils/locator.dart';
import '../venues/models/venue.dart';
import 'firestore_service.dart';
import 'images_service.dart';

class VenuesService {
  VenuesService(
      {required FirestoreService firestoreService,
      required StorageService storageService})
      : _firestoreService = firestoreService,
        _storageService = storageService;

  final FirestoreService _firestoreService;
  final StorageService _storageService;

  final _uploadProgressSubject = BehaviorSubject<int>.seeded(0);
  Stream<int> get uploadProgressStream => _uploadProgressSubject.stream;

  /// Create a new venue at the given location and return the id
  Future<String> createNewVenue(Map<String, Object?> data) async {
    return _firestoreService.addDoc(collectionPath: 'venues', data: data);
  }

  Future<String> getDownloadUrl(String storagePath) {
    return _storageService.getDownLoadUrl(storagePath: storagePath);
  }

  Stream<UploadEvent> uploadIconBytes(
      {required Uint8List bytes, required String storagePath}) {
    return _storageService.uploadBytes(bytes: bytes, storagePath: storagePath);
  }

  Stream<UploadEvent> uploadFile({
    required String localPath,
    required String storagePath,
  }) {
    return _storageService.uploadFile(
      localPath: localPath,
      storagePath: storagePath,
    );
  }

  Future<void> resizeLargeImage({
    required String localPath,
    required int smallSize,
  }) async {
    await locate<ImagesService>()
        .resizeImage(filePath: localPath, size: smallSize);
  }

  Future<void> updateVenue(
      {required String id, required Map<String, Object?> data}) {
    return _firestoreService.updateDoc(path: 'venues/$id', data: data);
  }

  Future<Set<Venue>> retrieveVenues() async {
    final json = await _firestoreService.getDocs(inCollectionPath: 'venues');
    return json.map<Venue>((json) {
      return Venue.fromJson(json);
    }).toSet();
  }

  Future<Venue?> retrieveVenue(String id) async {
    final json = await _firestoreService.getDoc(atPath: 'venues/$id');
    if (json == null) return null;
    return Venue.fromJson(json);
  }

  Future<void> deleteVenue({required Venue venue}) async {
    await _storageService.deleteFile(
      'venuePhotos',
      '${venue.id}_large',
    );
    await _storageService.deleteFile(
      'venuePhotos',
      '${venue.id}_icon',
    );
    await _firestoreService.deleteDoc(atPath: 'venues/${venue.id}');
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
