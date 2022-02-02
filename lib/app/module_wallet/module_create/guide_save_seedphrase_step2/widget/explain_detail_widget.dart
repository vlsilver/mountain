import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_wallet/module_create/widget/title_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../guide_save_seedphrase_step2_controller.dart';

class SecureExplainDetailWidget
    extends GetView<GuideSaveSeedPhraseStep2Controller> {
  const SecureExplainDetailWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextTitleWidget(
          title: 'secure_title'.tr,
        ),
        SizedBox(height: AppSizes.spaceNormal),
        Text.rich(
          TextSpan(
            text: 'guildWallet_step2_secury'.tr,
            style:
                AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black50),
            children: [
              TextSpan(
                text: 'guildWallet_step2_wallet'.tr,
                recognizer: TapGestureRecognizer()..onTap = () {},
                style: AppTextTheme.bodyText1
                    .copyWith(color: AppColorTheme.textAccent80),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSizes.spaceNormal),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(controller.icInfo),
            SizedBox(
              width: AppSizes.spaceSmall,
            ),
            Text(
              'guildWallet_step2_important'.tr,
              textAlign: TextAlign.center,
              style: AppTextTheme.bodyText2.copyWith(
                  color: AppColorTheme.textAccent, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: AppSizes.spaceLarge),
        _DetailTableScraft(),
        SizedBox(
          height: AppSizes.spaceMedium,
        ),
        _DetailTableOther()
      ],
    );
  }
}

class _DetailTableOther extends GetView<GuideSaveSeedPhraseStep2Controller> {
  const _DetailTableOther({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: AppSizes.spaceMedium,
          left: AppSizes.spaceMedium,
          right: AppSizes.spaceMedium),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
          color: AppColorTheme.focus),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'guildWallet_step2_otherOption'.tr,
            style: AppTextTheme.bodyText1.copyWith(
                fontSize: 13,
                color: AppColorTheme.black80,
                fontWeight: FontWeight.w600),
          ),
          Text.rich(
            TextSpan(
                text: 'guildWallet_step2_tips'.tr,
                style: AppTextTheme.bodyText2.copyWith(
                  color: AppColorTheme.black60,
                  height: 2,
                ),
                children: [
                  TextSpan(text: 'guildWallet_step2_store'.tr),
                  TextSpan(text: 'guildWallet_step2_store2'.tr),
                  TextSpan(text: 'guildWallet_step2_store3'.tr)
                ]),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}

class _DetailTableScraft extends GetView<GuideSaveSeedPhraseStep2Controller> {
  const _DetailTableScraft({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: AppSizes.spaceMedium,
          left: AppSizes.spaceMedium,
          right: AppSizes.spaceMedium),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
          color: AppColorTheme.focus),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('guildWallet_step2_hand'.tr,
                  style: AppTextTheme.bodyText1.copyWith(
                      fontSize: 13,
                      color: AppColorTheme.black80,
                      fontWeight: FontWeight.w600)),
              Expanded(
                child: Text.rich(
                  TextSpan(
                      text: 'guildWallet_step2_level'.tr,
                      style: AppTextTheme.bodyText1.copyWith(
                          fontSize: 13,
                          color: AppColorTheme.black80,
                          fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: 'guildWallet_step2_lvl'.tr,
                          style: AppTextTheme.bodyText1.copyWith(
                              fontSize: 13,
                              color: AppColorTheme.toggleableActiveColor,
                              fontWeight: FontWeight.w600),
                        )
                      ]),
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
          SizedBox(
            height: AppSizes.spaceSmall,
          ),
          Text(
            'guildWallet_step2_saveIt'.tr,
            style: AppTextTheme.bodyText2.copyWith(
              color: AppColorTheme.black60,
            ),
          ),
          Text.rich(
            TextSpan(
                text: 'guildWallet_step2_risk'.tr,
                style: AppTextTheme.bodyText2
                    .copyWith(color: AppColorTheme.black60, height: 2),
                children: [
                  TextSpan(text: 'guildWallet_step2_lost'.tr),
                  TextSpan(text: 'guildWallet_step2_forgot'.tr),
                  TextSpan(text: 'guildWallet_step2_someone'.tr)
                ]),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
