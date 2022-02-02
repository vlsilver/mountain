import 'dart:ui';

import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_wallet/module_create/widget/title_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../guide_save_seedphrase_setp1_controller.dart';

class SecureExplainTotalWidget
    extends GetView<GuideSaveSeedPhraseStep1Controller> {
  const SecureExplainTotalWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextTitleWidget(title: 'secure_title'.tr),
        SizedBox(height: AppSizes.spaceVeryLarge),
        Image.asset(controller.icSecure),
        SizedBox(height: AppSizes.spaceVeryLarge),
        _ExplainWidget(),
        SizedBox(height: AppSizes.spaceSmall),
        Text(
          'secure_important_desc'.tr,
          textAlign: TextAlign.center,
          style: AppTextTheme.bodyText1.copyWith(
              color: AppColorTheme.black, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _ExplainWidget extends GetView<GuideSaveSeedPhraseStep1Controller> {
  const _ExplainWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'secure_desc_1'.tr,
        style: AppTextTheme.bodyText2
            .copyWith(color: AppColorTheme.black50, fontSize: 13),
        children: [
          TextSpan(
            text: 'secure_desc_2'.tr,
            recognizer: TapGestureRecognizer()..onTap = () {},
            style: AppTextTheme.bodyText2
                .copyWith(color: AppColorTheme.textAccent, fontSize: 13),
          ),
          TextSpan(
            text: 'secure_desc_3'.tr,
            style: AppTextTheme.bodyText2
                .copyWith(color: AppColorTheme.black50, fontSize: 13),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
