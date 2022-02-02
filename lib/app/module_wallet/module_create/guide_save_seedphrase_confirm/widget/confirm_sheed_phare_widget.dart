import 'dart:ui';

import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_wallet/module_create/widget/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../guide_save_seedphrase_confirm_controller.dart';

class ConfirmSheedPhraseWidget
    extends GetView<GuideSaveSeedPhraseConfirmController> {
  const ConfirmSheedPhraseWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: AppSizes.spaceVeryLarge),
        TextTitleWidget(title: 'guildWallet_confirm_step2'.tr),
        SizedBox(
          height: AppSizes.spaceMax,
        ),
        GetBuilder<GuideSaveSeedPhraseConfirmController>(
          id: EnumUpdateGuideSaveSeedPhraseConfirm.CONFIRM_GROUP,
          builder: (_) {
            return Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 0.0, vertical: AppSizes.spaceVeryLarge),
              decoration: BoxDecoration(
                color: AppColorTheme.card,
                border: _.isCorret == null
                    ? null
                    : _.isCorret!
                        ? Border.all(color: AppColorTheme.toggleableActiveColor)
                        : Border.all(color: AppColorTheme.error),
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
              ),
              child: Column(
                children: [
                  Text(
                    'guildWallet_confirm_step3'.tr,
                    textAlign: TextAlign.center,
                    style: AppTextTheme.bodyText1
                        .copyWith(color: AppColorTheme.black60),
                  ),
                  SizedBox(height: AppSizes.spaceVeryLarge),
                  Row(
                      children: _.confirmSeedPhrase3
                          .map((item) => _ItemSeedPhraseWidget(item: item))
                          .toList()),
                ],
              ),
            );
          },
        ),
        SizedBox(height: AppSizes.spaceVeryLarge),
        GetBuilder<GuideSaveSeedPhraseConfirmController>(
          id: EnumUpdateGuideSaveSeedPhraseConfirm.CHOICE_GROUP,
          builder: (_) {
            return Wrap(
              alignment: WrapAlignment.center,
              runSpacing: AppSizes.spaceMedium,
              spacing: AppSizes.spaceMedium,
              children: controller.confirmSeedPhrase5
                  .map((item) => _ItemSeedPhraseChoiceWidget(
                        item: item,
                      ))
                  .toList(),
            );
          },
        ),
        SizedBox(
          height: AppSizes.spaceVeryLarge,
        ),
      ],
    );
  }
}

class _ItemSeedPhraseWidget
    extends GetView<GuideSaveSeedPhraseConfirmController> {
  const _ItemSeedPhraseWidget({
    Key? key,
    required this.item,
  }) : super(key: key);
  final ConfirmItem item;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceSmall),
        child: InkWell(
          onTap: () {
            controller.handleItemConfirmOnTap(item.index);
          },
          child: GetBuilder<GuideSaveSeedPhraseConfirmController>(
            id: item.index,
            builder: (_) {
              return Container(
                padding: EdgeInsets.symmetric(
                    vertical: AppSizes.spaceNormal,
                    horizontal: AppSizes.spaceVerySmall),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColorTheme.focus,
                    border: controller.isItemActive(item.index)
                        ? Border.all(color: AppColorTheme.accent)
                        : null,
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadiusSmall)),
                child: Text.rich(
                  TextSpan(
                      text: (item.indexInSeedPhrase + 1).toString() + ' .  ',
                      children: [
                        TextSpan(
                          text: item.currentValue,
                          style: AppTextTheme.bodyText1.copyWith(
                              color: AppColorTheme.black,
                              fontWeight: FontWeight.w600),
                        )
                      ]),
                  textAlign: TextAlign.justify,
                  style: AppTextTheme.bodyText1.copyWith(
                      color: AppColorTheme.hover, fontWeight: FontWeight.w600),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ItemSeedPhraseChoiceWidget
    extends GetView<GuideSaveSeedPhraseConfirmController> {
  const _ItemSeedPhraseChoiceWidget({
    Key? key,
    required this.item,
  }) : super(key: key);
  final ConfirmItem item;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.handleItemChoiceOnTap(item.value);
      },
      child: Container(
          padding: EdgeInsets.all(AppSizes.spaceNormal),
          decoration: BoxDecoration(
              color: AppColorTheme.focus,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall)),
          child: Text(
            item.value,
            style: AppTextTheme.bodyText1.copyWith(
                color: AppColorTheme.black, fontWeight: FontWeight.w600),
          )),
    );
  }
}
