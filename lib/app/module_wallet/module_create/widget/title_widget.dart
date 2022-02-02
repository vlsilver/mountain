import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/module_wallet/module_create/create_wallet/create_wallet_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextTitleWidget extends GetView<CreateWalletController> {
  const TextTitleWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: controller.tagHeroTitleText,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: AppTextTheme.headline2.copyWith(
            color: AppColorTheme.accent, decoration: TextDecoration.none),
      ),
    );
  }
}
