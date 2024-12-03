import 'package:flutter/material.dart';

import '../../../services/venues_service.dart';
import '../../../utils/locator.dart';

class VenueTypeDropdown extends StatefulWidget {
  const VenueTypeDropdown({super.key});

  static const list = ['half-court', 'full-court', 'multi-court'];

  @override
  State<VenueTypeDropdown> createState() => _VenueTypeDropdownState();
}

class _VenueTypeDropdownState extends State<VenueTypeDropdown> {
  String dropdownValue = VenueTypeDropdown.list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      // elevation: 16,
      // style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        // color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        if (value != null) {
          final typeNum = VenueTypeDropdown.list.indexOf(value) + 1;
          locate<VenuesService>().updateNewVenue(type: typeNum);
        }
        setState(() {
          dropdownValue = value!;
        });
      },
      items:
          VenueTypeDropdown.list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
