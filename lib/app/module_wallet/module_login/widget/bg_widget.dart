import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/values/asset_values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login_controller.dart';

class LoginBackgroundWidget extends GetView<LoginController> {
  const LoginBackgroundWidget({
    required this.child,
    Key? key,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          color: AppColorTheme.accent,
          image: DecorationImage(
            image: AssetImage(AppAssets.globalBg),
            fit: BoxFit.cover,
          )),
      child: child,
    );
  }
}
