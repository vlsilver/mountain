import 'package:flutter/material.dart';

class GapItem extends StatelessWidget {
  final double width;

  const GapItem({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(width: width);
}
