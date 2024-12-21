import 'package:flutter/material.dart';

import '../../models/local_venue.dart';

class VenueSizeDropdown extends StatefulWidget {
  const VenueSizeDropdown({
    required LocalVenue localVenue,
    required this.updateStateCallback,
    super.key,
  }) : _localVenue = localVenue;

  static const list = ['half-court', 'full-court', 'multi-court'];

  final LocalVenue _localVenue;
  final void Function(int) updateStateCallback;

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
          widget._localVenue.size = sizeNum;
          widget.updateStateCallback(sizeNum);
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
