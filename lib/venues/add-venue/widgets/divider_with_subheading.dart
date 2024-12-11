import 'package:flutter/material.dart';

class DividerWithSubheading extends StatelessWidget {
  const DividerWithSubheading(this.subheading, {super.key});

  final String subheading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Container(
          padding: const EdgeInsets.only(left: 20),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              subheading,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ],
    );
  }
}
