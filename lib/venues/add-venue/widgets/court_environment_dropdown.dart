import 'package:flutter/material.dart';

import '../../models/local_venue.dart';

class CourtEnvironmentDropdown extends StatefulWidget {
  const CourtEnvironmentDropdown({required LocalVenue localVenue, super.key})
      : _localVenue = localVenue;

  static const list = ['outdoor', 'indoor', 'covered-outdoor'];

  final LocalVenue _localVenue;

  @override
  State<CourtEnvironmentDropdown> createState() =>
      _CourtEnvironmentDropdownState();
}

class _CourtEnvironmentDropdownState extends State<CourtEnvironmentDropdown> {
  String dropdownValue = CourtEnvironmentDropdown.list.first;

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
          final environmentNum = CourtEnvironmentDropdown.list.indexOf(value);
          widget._localVenue.environment = environmentNum;
        }

        setState(() {
          dropdownValue = value!;
        });
      },
      items: CourtEnvironmentDropdown.list
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
