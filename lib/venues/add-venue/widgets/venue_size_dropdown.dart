import 'package:flutter/material.dart';

import '../../../services/venues_service.dart';
import '../../../utils/locator.dart';

class VenueSizeDropdown extends StatefulWidget {
  const VenueSizeDropdown({super.key});

  static const list = ['half-court', 'full-court', 'multi-court'];

  @override
  State<VenueSizeDropdown> createState() => _VenueSizeDropdownState();
}

class _VenueSizeDropdownState extends State<VenueSizeDropdown> {
  String dropdownValue = VenueSizeDropdown.list.first;

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
          final sizeNum = VenueSizeDropdown.list.indexOf(value) + 1;
          locate<VenuesService>().updateNewVenue(size: sizeNum);
        }
        setState(() {
          dropdownValue = value!;
        });
      },
      items:
          VenueSizeDropdown.list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
