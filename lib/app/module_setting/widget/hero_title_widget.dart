import 'package:flutter/cupertino.dart';

class HeroTitleWidget extends StatelessWidget {
  const HeroTitleWidget({
    Key? key,
    required this.title,
    required this.style,
    this.align = TextAlign.center,
  }) : super(key: key);

  final String title;
  final TextStyle style;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: title,
      child: Text(
        title,
        style: style.copyWith(decoration: TextDecoration.none),
        textAlign: align,
      ),
    );
  }
}
