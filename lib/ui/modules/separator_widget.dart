import 'package:flutter/material.dart';

class SeparatorWidget extends StatelessWidget {
  final String title;

  const SeparatorWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 5),
        Text(title.toUpperCase(), style: Theme.of(context).textTheme.headline5),
        const SizedBox(width: 10),
        const Expanded(
          child: Divider(
            color: Colors.black,
            thickness: 2,
            height: 10,
          ),
        ),
      ],
    );
  }
}
