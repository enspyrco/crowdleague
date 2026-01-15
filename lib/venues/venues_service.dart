import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:crowdleague/utils/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';

import '../players/enums/pic_size.dart';
import '../players/models/player.dart';
import '../utils/api_keys.dart';
import 'models/upload_event.dart';
import 'models/venue.dart';

class VenuesService {
  VenuesService({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required FirebaseFunctions cloudFunctions,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _storage = storage,
        _cloudFunctions = cloudFunctions,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseFunctions _cloudFunctions;
  final FirebaseAuth _auth;

  final _uploadProgressSubject = BehaviorSubject<int>.seeded(0);
  Stream<int> get uploadProgressStream => _uploadProgressSubject.stream;

  /// Create a new venue at the given location and return the id
  Future<String> createNewVenue(Map<String, Object?> data) async {
    final ref = await _firestore.collection('venues').add(data);
    return ref.id;
  }

  // Future<Uint8List?> downloadPhoto(String venueId, PicSize picSize) {
  //   final String photoUriString;
  //   if (picSize == PicSize.small) {
  //     photoUriString = 'venuePhotos/${venueId}_small.jpg';
  //   } else if (picSize == PicSize.medium) {
  //     photoUriString = 'venuePhotos/${venueId}_medium.jpg';
  //   } else {
  //     photoUriString = 'venuePhotos/${venueId}_large.jpg';
  //   }

  //   final storageRef = _storage.ref(photoUriString);
  //   return storageRef.getData();
  // }

  /// Get photo URL for a venue photo at a specific index
  String getPhotoUrl(String venueId, PicSize picSize, {int photoIndex = 0}) {
    final String suffix;
    if (picSize == PicSize.small) {
      suffix = 'small';
    } else if (picSize == PicSize.medium) {
      suffix = 'medium';
    } else {
      suffix = 'large';
    }

    final photoUriString = '${venueId}_${photoIndex}_$suffix.jpg';
    return 'https://storage.googleapis.com/$kVenuesBucket/$photoUriString';
  }

  /// Get all photo URLs for a venue
  List<String> getAllPhotoUrls(
      String venueId, int photoCount, PicSize picSize) {
    return List.generate(
      photoCount,
      (index) => getPhotoUrl(venueId, picSize, photoIndex: index),
    );
  }

  Future<Uint8List?> downloadIcon(String venueId) {
    final storageRef = _storage.ref('${venueId}_icon');
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
    // Delete all photos for each index
    for (int i = 0; i < venue.photoCount; i++) {
      try {
        await _storage.ref('${venue.id}_${i}_large.jpg').delete();
      } catch (_) {}
      try {
        await _storage.ref('${venue.id}_${i}_medium.jpg').delete();
      } catch (_) {}
      try {
        await _storage.ref('${venue.id}_${i}_small.jpg').delete();
      } catch (_) {}
      try {
        await _storage.ref('${venue.id}_$i.jpg').delete();
      } catch (_) {}
    }
    // Delete icon
    try {
      await _storage.ref('${venue.id}_icon').delete();
    } catch (_) {}
    await _firestore.collection('venues').doc(venue.id).delete();
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

  /// Convert an address string to lat/lng coordinates (forward geocoding)
  Future<(double latitude, double longitude)?> searchAddress(
      String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=$reverseGeocodingApiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 'OK' && jsonResponse['results'] != null) {
        final firstResult = jsonResponse['results'][0];
        final location = firstResult['geometry']['location'];
        final lat = location['lat'] as double;
        final lng = location['lng'] as double;
        return (lat, lng);
      }
    }
    return null;
  }

  // ==================== Crew Operations ====================

  /// Join the crew at a venue
  Future<void> joinVenueCrew(String venueId) async {
    await _cloudFunctions.httpsCallable('joinVenueCrew').call({
      'venueId': venueId,
      'dbName': kDatabaseName,
    });
  }

  /// Leave the crew at a venue
  Future<void> leaveVenueCrew(String venueId) async {
    await _cloudFunctions.httpsCallable('leaveVenueCrew').call({
      'venueId': venueId,
      'dbName': kDatabaseName,
    });
  }

  /// Get the crew members for a venue
  Future<List<Player>> getVenueCrewMembers(String venueId) async {
    final venue = await retrieveVenue(venueId);
    if (venue == null) return [];

    if (venue.crewMemberIds.isEmpty) return [];

    final players = <Player>[];
    for (final memberId in venue.crewMemberIds) {
      final doc = await _firestore.collection('profiles').doc(memberId).get();
      final data = doc.data();
      if (data != null) {
        players.add(Player.fromJsonWithId(memberId, data));
      }
    }
    return players;
  }

  /// Check if the current user is in a venue's crew
  bool isUserInVenueCrew(Venue venue) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return false;
    return venue.crewMemberIds.contains(userId);
  }
}
