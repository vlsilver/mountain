import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_wallet/module_create/widget/title_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../guide_save_seedphrase_controller.dart';

class CompleteWidget extends GetView<GuideSaveSeedPhraseCompleteController> {
  const CompleteWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SizedBox(height: AppSizes.spaceVeryLarge),
      SvgPicture.asset(controller.icComplete),
      SizedBox(height: AppSizes.spaceMax),
      TextTitleWidget(title: 'guildWallet_setup_complete'.tr),
      SizedBox(height: AppSizes.spaceVeryLarge),
      Text.rich(
        TextSpan(
            text: 'guildWallet_complete_desc'.tr,
            style:
                AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black60),
            children: [
              TextSpan(
                text: 'guildWallet_complete_desc1'.tr,
                style: AppTextTheme.bodyText1
                    .copyWith(color: AppColorTheme.textAccent80),
              )
            ]),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: AppSizes.spaceNormal),
      Text.rich(
        TextSpan(
            text: 'guildWallet_complete_desc2'.tr,
            style:
                AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black60),
            children: [
              TextSpan(
                text: 'guildWallet_complete_desc3'.tr,
                style: AppTextTheme.bodyText1
                    .copyWith(color: AppColorTheme.textAccent80),
              )
            ]),
        textAlign: TextAlign.center,
      ),
    ]);
  }
}
