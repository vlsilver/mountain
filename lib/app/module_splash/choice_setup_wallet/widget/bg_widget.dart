import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/values/asset_values.dart';
import 'package:flutter/material.dart';

class SetupWalletBackgroundWidget extends StatelessWidget {
  const SetupWalletBackgroundWidget({
    required this.child,
    Key? key,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.globalBg),
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          colors: [
            AppColorTheme.accent,
            AppColorTheme.accent80,
            AppColorTheme.accent00
          ],
          stops: [0.0, 0.3, 1.0],
          begin: Alignment(0.0, -1.0),
          end: Alignment(0.0, 1.2),
        ),
      ),
      child: child,
    );
  }
}
