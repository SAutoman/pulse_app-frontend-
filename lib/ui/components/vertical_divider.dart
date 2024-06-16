import 'package:flutter/material.dart';

class CustomVerticalDivider extends StatelessWidget {
  const CustomVerticalDivider(
      {super.key, required this.color, required this.height});

  final Color color;
  final int height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.toDouble(), // Adjust the height as needed
      child: VerticalDivider(
        color: color,
        thickness: 1, // Adjust thickness as needed
        width: 20, // Adjust width as needed to control spacing
      ),
    );
  }
}
