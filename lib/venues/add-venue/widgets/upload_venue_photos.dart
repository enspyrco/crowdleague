import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';

import '../../../services/images_service.dart';
import '../../../utils/locator.dart';
import '../../models/local_venue.dart';
import 'venue_icon.dart';

class UploadVenuePhotos extends StatefulWidget {
  const UploadVenuePhotos({
    super.key,
    required LocalVenue localVenue,
    required this.onPhotosChanged,
  }) : _localVenue = localVenue;

  final LocalVenue _localVenue;
  final VoidCallback onPhotosChanged;

  @override
  State<UploadVenuePhotos> createState() => _UploadVenuePhotosState();
}

class _UploadVenuePhotosState extends State<UploadVenuePhotos> {
  Object? _error;
  bool _loading = false;
  int _currentPage = 0;
  final _pageController = PageController();
  final _screenshotController = ScreenshotController();

  static const int maxPhotos = 5;

  Future<void> _addPhoto(ImageSource source) async {
    if (widget._localVenue.photoPaths.length >= maxPhotos) return;

    try {
      setState(() => _loading = true);

      XFile? pickedFile = await locate<ImagesService>().pickImage(source);
      if (pickedFile == null) {
        if (mounted) setState(() => _loading = false);
        return;
      }

      final croppedFilePath =
          await locate<ImagesService>().cropImage(pickedFile);
      if (croppedFilePath == null) {
        if (mounted) setState(() => _loading = false);
        return;
      }

      widget._localVenue.photoPaths.add(croppedFilePath);
      final isFirstPhoto = widget._localVenue.photoPaths.length == 1;

      if (mounted) {
        setState(() => _loading = false);
        // Jump to the new photo after the PageView is built
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              widget._localVenue.photoPaths.length - 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
          // Generate icon from first photo only - must happen AFTER setState
          // so the Screenshot widget is in the tree
          if (isFirstPhoto) {
            await _regenerateIcon();
          }
        });
      }
      widget.onPhotosChanged();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
          _loading = false;
        });
      }
    }
  }

  Future<void> _regenerateIcon() async {
    if (widget._localVenue.photoPaths.isEmpty) {
      widget._localVenue.iconBytes = null;
      return;
    }

    // Wait for the widget to build with the new photo path
    await Future.delayed(const Duration(milliseconds: 150));

    final bytes = await _screenshotController.capture(
      delay: const Duration(milliseconds: 100),
    );
    widget._localVenue.iconBytes = bytes;
  }

  void _removePhoto(int index) {
    setState(() {
      widget._localVenue.photoPaths.removeAt(index);

      // Adjust current page if needed
      if (_currentPage >= widget._localVenue.photoPaths.length) {
        _currentPage = widget._localVenue.photoPaths.length - 1;
        if (_currentPage < 0) _currentPage = 0;
      }

      // If first photo removed, regenerate icon from new first photo
      if (index == 0) {
        _regenerateIcon();
      }
    });
    widget.onPhotosChanged();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget._localVenue.photoPaths;
    final hasPhotos = photos.isNotEmpty;
    final canAddMore = photos.length < maxPhotos;

    return Column(
      children: [
        // Photo display area
        SizedBox(
          height: 200,
          child: hasPhotos
              ? Stack(
                  children: [
                    // Screenshot widget for icon generation - placed first so it's
                    // covered by PageView. The VenueIcon is only 16x16 pixels.
                    Screenshot(
                      controller: _screenshotController,
                      child: VenueIcon(filePath: photos.first),
                    ),
                    // PageView for swiping through photos (covers the tiny VenueIcon)
                    PageView.builder(
                      controller: _pageController,
                      itemCount: photos.length,
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                      },
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            // Photo
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(photos[index]),
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Delete button
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () => _removePhoto(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            // Map icon badge on first photo
                            if (index == 0)
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Map Icon',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    // Page indicator dots
                    if (photos.length > 1)
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            photos.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == _currentPage
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Photo counter
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${photos.length}/$maxPhotos',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text(
                        'Add venue photos (up to $maxPhotos)',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
        ),
        const SizedBox(height: 16),
        // Add photo buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: canAddMore ? () => _addPhoto(ImageSource.gallery) : null,
              icon: const Icon(Icons.photo),
              label: const Text('Gallery'),
            ),
            const SizedBox(width: 16),
            TextButton.icon(
              onPressed: canAddMore ? () => _addPhoto(ImageSource.camera) : null,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
            ),
          ],
        ),
        if (_loading) ...[
          const SizedBox(height: 16),
          const CircularProgressIndicator(),
        ],
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              _error.toString(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
