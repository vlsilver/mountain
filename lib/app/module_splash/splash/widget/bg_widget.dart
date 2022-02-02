import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/values/asset_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:base_source/app/core/values/size_values.dart';

class SplashBackgroundWidget extends StatelessWidget {
  const SplashBackgroundWidget({
    required this.child,
    Key? key,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColorTheme.accent,
              AppColorTheme.accent80,
              AppColorTheme.accent00
            ],
            stops: [0.0, 0.3, 1.0],
            begin: Alignment(0.0, 1.0),
            end: Alignment(0.0, -1.0),
          ),
        ),
      ),
      Positioned(
        top: 185.0.hs,
        right: 0.0,
        child: SvgPicture.asset(
          AppAssets.splashBg,
          width: 158.0.ws,
        ),
      ),
      child,
    ]);
  }
}
