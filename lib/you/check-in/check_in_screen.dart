import 'package:flutter/material.dart';

import '../../utils/widgets/divider_with_subheading.dart';
import 'widgets/venues_search.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  String? _selectedVenueId;

  void updateSelectedVenueId(String id) {
    _selectedVenueId = id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Check In'),
        ),
        body: Column(
          children: [
            const DividerWithSubheading('Location'),
            VenuesSearch(),
          ],
        ));
  }
}
