import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/venues_service.dart';
import '../../utils/locator.dart';
import '../models/venue.dart';

class VenueDetailScreen extends StatefulWidget {
  const VenueDetailScreen({required this.venueId, super.key});

  final String venueId;

  @override
  State<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  Venue? _venue;
  bool _deleting = false;

  Future<void> _retrieveVenue() async {
    final venue = await locate<VenuesService>().retrieveVenue(widget.venueId);
    if (mounted) {
      setState(() {
        _venue = venue;
      });
    }
  }

  Future<void> _deleteVenue() async {
    if (mounted) {
      setState(() {
        _deleting = true;
      });
    }
    await locate<VenuesService>().deleteVenue(venue: _venue!);
    if (mounted) {
      setState(() {
        _deleting = false;
      });
      context.pop(_venue!.id);
    }
  }

  @override
  void initState() {
    super.initState();
    _retrieveVenue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (_venue == null || _deleting)
            const AspectRatio(
              aspectRatio: 1.0,
              child: Center(child: CircularProgressIndicator()),
            ),
          if (_venue != null && !_deleting) ...[
            Stack(
              children: [
                Image.network(
                  _venue!.largePhotoUrl,
                  frameBuilder: (context, child, frame, sync) {
                    if (frame == null) {
                      return const AspectRatio(
                        aspectRatio: 1.0,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return child;
                  },
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return AspectRatio(
                      aspectRatio: 1.0,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, exception, stackTrace) {
                    return Text(
                      exception.toString(),
                      style: const TextStyle(color: Colors.red),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 45.0),
                    child: IconButton(
                        color: Colors.white,
                        style: IconButton.styleFrom(
                            backgroundColor: Colors.grey.withOpacity(0.7)),
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_ios_new)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _venue!.name,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(fontWeight: FontWeight.w300),
              ),
            ),
            const SizedBox(height: 15),
            InkWell(
              child: Text(
                _venue!.address,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.blue),
              ),
              onTap: () => launchUrl(
                Uri.parse(
                    'https://www.google.com/maps/place/${_venue!.address}/@${_venue!.latitude},${_venue!.longitude},18z'),
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
                onPressed: () {
                  _deleteVenue();
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                )),
          ],
        ],
      ),
    );
  }
}
