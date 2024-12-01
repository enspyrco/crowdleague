import 'package:crowdleague/services/venues_service.dart';
import 'package:flutter/material.dart';

import '../utils/locator.dart';

class VenueFacingDropdown extends StatefulWidget {
  const VenueFacingDropdown({super.key});

  static const list = ['east-west', 'north-south'];

  @override
  State<VenueFacingDropdown> createState() => _VenueFacingDropdownState();
}

class _VenueFacingDropdownState extends State<VenueFacingDropdown> {
  String dropdownValue = VenueFacingDropdown.list.first;

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
          final facingNum = VenueFacingDropdown.list.indexOf(value) + 1;
          locate<VenuesService>().updateNewVenue(facing: facingNum);
        }

        setState(() {
          dropdownValue = value!;
        });
      },
      items: VenueFacingDropdown.list
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
