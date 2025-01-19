import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';

import '../utils/api_keys.dart';
import '../venues/models/upload_event.dart';
import '../venues/models/venue.dart';

class VenuesService {
  VenuesService({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  })  : _firestore = firestore,
        _storage = storage;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  final _uploadProgressSubject = BehaviorSubject<int>.seeded(0);
  Stream<int> get uploadProgressStream => _uploadProgressSubject.stream;

  /// Create a new venue at the given location and return the id
  Future<String> createNewVenue(Map<String, Object?> data) async {
    final ref = await _firestore.collection('venues').add(data);
    return ref.id;
  }

  Future<Uint8List?> downloadLargePhoto(String venueId) {
    final storageRef = _storage.ref('venuePhotos/${venueId}_large');
    return storageRef.getData();
  }

  Future<Uint8List?> downloadIcon(String venueId) {
    final storageRef = _storage.ref('venuePhotos/${venueId}_icon');
    return storageRef.getData();
  }

  Stream<UploadEvent> uploadBytes(
      {required Uint8List bytes, required String storagePath}) {
    return _storage
        .ref(storagePath)
        .putData(bytes)
        .snapshotEvents
        .map<UploadEvent>((snapshot) {
      return UploadEvent(
          transferred: snapshot.bytesTransferred, total: snapshot.totalBytes);
    });
  }

  Stream<UploadEvent> uploadFile({
    required String localPath,
    required String storagePath,
  }) {
    return _storage
        .ref(storagePath)
        .putFile(File(localPath))
        .snapshotEvents
        .map<UploadEvent>((snapshot) {
      return UploadEvent(
          transferred: snapshot.bytesTransferred, total: snapshot.totalBytes);
    });
  }

  Future<void> updateVenue(
      {required String id, required Map<String, Object?> data}) {
    return _firestore.collection('venues').doc(id).update(data);
  }

  Future<List<Venue>> retrieveVenues() async {
    final docsSnapshot = await _firestore.collection('venues').get();
    return docsSnapshot.docs.map<Venue>((snapshot) {
      final json = snapshot.data();
      json['id'] = snapshot.id;
      return Venue.fromJson(json);
    }).toList();
  }

  Future<Venue?> retrieveVenue(String id) async {
    final reference = await _firestore.collection('venues').doc(id).get();
    final json = reference.data();
    if (json == null) return null;
    json['id'] = reference.id;
    return Venue.fromJson(json);
  }

  Future<void> deleteVenue({required Venue venue}) async {
    await _storage.ref('venuePhotos').child('${venue.id}_large').delete();
    await _storage.ref('venuePhotos').child('${venue.id}_small').delete();
    await _storage.ref('venuePhotos').child('${venue.id}_icon').delete();
    _firestore.collection('venues').doc(venue.id).delete();
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
