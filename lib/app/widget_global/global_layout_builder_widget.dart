import 'package:flutter/material.dart';

class GlobalLayoutBuilderWidget extends StatelessWidget {
  const GlobalLayoutBuilderWidget({
    Key? key,
    this.padding = const EdgeInsets.all(0.0),
    required this.child,
  }) : super(key: key);
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contraint) {
      return SingleChildScrollView(
        padding: padding,
        physics: BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: contraint.maxHeight),
          child: IntrinsicHeight(child: child),
        ),
      );
    });
  }
}
