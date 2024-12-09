import 'package:crowdleague/services/venues_service.dart';
import 'package:flutter/material.dart';

import '../../../utils/locator.dart';

class CourtSurfaceDropdown extends StatefulWidget {
  const CourtSurfaceDropdown({super.key});

  static const list = ['concrete', 'wood', 'astro-turf'];

  @override
  State<CourtSurfaceDropdown> createState() => _CourtSurfaceDropdownState();
}

class _CourtSurfaceDropdownState extends State<CourtSurfaceDropdown> {
  String dropdownValue = CourtSurfaceDropdown.list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      underline: Container(
        height: 2,
      ),
      onChanged: (String? value) {
        if (value != null) {
          final surfaceNum = CourtSurfaceDropdown.list.indexOf(value) + 1;
          locate<VenuesService>().updateNewVenue(surface: surfaceNum);
        }

        setState(() {
          dropdownValue = value!;
        });
      },
      items: CourtSurfaceDropdown.list
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
