// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class ImageBytesCache {
  ImageBytesCache({
    required FirebaseStorage storage,
    int staleSeconds = 15,
  })  : _storage = storage,
        _staleSeconds = staleSeconds;

  final FirebaseStorage _storage;
  final int _staleSeconds;

  final Map<String, ImageCacheItem> _cache = {};

  Future<Uint8List> retrieveImage(String uri) async {
    ImageCacheItem? item = _cache[uri];

    if (item == null ||
        DateTime.now().difference(item.timestamp).inSeconds > _staleSeconds) {
      final imageBytes = await _storage.ref(uri).getData() ?? Uint8List(0);
      _cache[uri] =
          ImageCacheItem(imageBytes: imageBytes, timestamp: DateTime.now());
    }

    return _cache[uri]!.imageBytes;
  }
}

class ImageCacheItem {
  ImageCacheItem({
    required this.imageBytes,
    required this.timestamp,
  });

  Uint8List imageBytes;
  DateTime timestamp;
}
