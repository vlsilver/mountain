import 'package:base_source/app/core/values/asset_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GlobalLogoWidget extends StatelessWidget {
  const GlobalLogoWidget({
    Key? key,
    this.height,
    this.color,
    this.type = 2,
  }) : super(key: key);
  final double? height;
  final Color? color;
  final int type;
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      type == 1 ? AppAssets.globalLogo1 : AppAssets.globalLogo2,
      height: height,
      color: color,
    );
  }
}
