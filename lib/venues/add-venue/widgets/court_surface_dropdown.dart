import 'package:flutter/material.dart';

import '../../models/local_venue.dart';

class CourtSurfaceDropdown extends StatefulWidget {
  const CourtSurfaceDropdown({required LocalVenue localVenue, super.key})
      : _localVenue = localVenue;

  static const list = ['concrete', 'wood', 'astro-turf', 'rubber'];

  final LocalVenue _localVenue;

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
          widget._localVenue.surface = surfaceNum;
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
