import 'package:base_source/app/widget_global/global_logo_widget.dart';
import 'package:flutter/cupertino.dart';

class HeroLogoWidget extends StatelessWidget {
  const HeroLogoWidget({
    Key? key,
    this.title,
  }) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: title ?? 'setting_logo_hero',
      child: GlobalLogoWidget(height: 40.0),
    );
  }
}
