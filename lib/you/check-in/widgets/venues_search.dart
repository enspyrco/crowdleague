import 'package:crowdleague/venues/venues_service.dart';
import 'package:flutter/material.dart';

import '../../../utils/locator.dart';

class VenuesSearch extends StatefulWidget {
  const VenuesSearch({required this.setVenueIdCallback, super.key});

  final void Function(String) setVenueIdCallback;

  @override
  State<VenuesSearch> createState() => _VenuesSearchState();
}

class _VenuesSearchState extends State<VenuesSearch> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchAnchor(
          builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0)),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          leading: const Icon(Icons.search),
        );
      }, suggestionsBuilder:
              (BuildContext context, SearchController controller) async {
        final venues = await locate<VenuesService>().retrieveVenues();

        return venues.map<ListTile>((venue) {
          return ListTile(
            title: Text(venue.name),
            onTap: () {
              setState(() {
                controller.closeView(venue.name);
                widget.setVenueIdCallback(venue.id);
              });
            },
          );
        });
      }),
    );
  }
}
