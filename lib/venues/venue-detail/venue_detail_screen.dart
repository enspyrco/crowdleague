import 'package:crowdleague/players/enums/pic_size.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:crowdleague/services/payment_service.dart';

import '../../services/user_service.dart';
import '../venues_service.dart';
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
  bool _processingPayment = false;
  int _currentPhotoIndex = 0;
  final _pageController = PageController();

  // Booking price in cents - could be fetched from venue data or pricing service
  int get _bookingPriceInCents => _venue?.bookingPrice ?? 2000; // Default $20.00

  String get _formattedPrice {
    final dollars = _bookingPriceInCents / 100;
    return '\$${dollars.toStringAsFixed(2)}';
  }

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

  Future<void> _payToBook() async {
    setState(() => _processingPayment = true);

    try {
      await locate<PaymentService>().initPaymentSheet(
        amount: _bookingPriceInCents,
        currency: 'aud',
        venueId: widget.venueId,
        description: 'Venue booking: ${_venue?.name ?? widget.venueId}',
      );

      final success = await locate<PaymentService>().presentPaymentSheet();

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking successful!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on PaymentException catch (e) {
      if (mounted && e.code != 'cancelled') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _processingPayment = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _retrieveVenue();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                AspectRatio(
                  aspectRatio: 1.0,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _venue!.photoCount,
                    onPageChanged: (index) {
                      setState(() => _currentPhotoIndex = index);
                    },
                    itemBuilder: (context, index) {
                      return Image.network(
                        locate<VenuesService>().getPhotoUrl(
                          widget.venueId,
                          PicSize.medium,
                          photoIndex: index,
                        ),
                        frameBuilder: (context, child, frame, sync) {
                          if (frame == null) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return child;
                        },
                        errorBuilder: (context, exception, stackTrace) {
                          return Center(
                            child: Icon(Icons.broken_image,
                                size: 48, color: Colors.grey),
                          );
                        },
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                // Back button
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 45.0),
                    child: IconButton(
                        color: Colors.white,
                        style: IconButton.styleFrom(
                            backgroundColor:
                                Colors.grey.withValues(alpha: 0.7)),
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_ios_new)),
                  ),
                ),
                // Page indicator dots
                if (_venue!.photoCount > 1)
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _venue!.photoCount,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentPhotoIndex
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton.icon(
                onPressed: _processingPayment ? null : _payToBook,
                icon: _processingPayment
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.payment),
                label: Text(_processingPayment
                    ? 'Processing...'
                    : 'Book Venue ($_formattedPrice)'),
              ),
            ),
            if (_venue != null &&
                _venue!.createdBy == locate<UserService>().currentUserId!)
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
