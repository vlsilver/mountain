import 'dart:ui';

import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_wallet/module_create/widget/title_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../guide_save_seedphrase_step3_controller.dart';

class ShowSheedPhraseWidget
    extends GetView<GuideSaveSeedPhraseStep3Controller> {
  const ShowSheedPhraseWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AppSizes.spaceVeryLarge),
        TextTitleWidget(title: 'guildWallet_step3_save'.tr),
        SizedBox(
          height: AppSizes.spaceMedium,
        ),
        Text(
          'guildWallet_step3_reqCode'.tr,
          textAlign: TextAlign.center,
          style: AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black60),
        ),
        SizedBox(
          height: AppSizes.spaceVeryLarge,
        ),
        Stack(
          children: [
            _ListSeedPhraseWidget(),
            _DialogAnimationWidget(),
          ],
        )
      ],
    );
  }
}

class _ListSeedPhraseWidget
    extends GetView<GuideSaveSeedPhraseStep3Controller> {
  const _ListSeedPhraseWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(4, (indexColunm) => indexColunm)
          .map((indexColunm) => Row(
                children: List.generate(3, (index) => index).map((index) {
                  final indexSeedPhrase = (indexColunm) * 3 + (index + 1);
                  return Expanded(
                    child: _ItemSeedPhraseWidget(
                      index: indexSeedPhrase,
                    ),
                  );
                }).toList(),
              ))
          .toList(),
    );
  }
}

class _ItemSeedPhraseWidget
    extends GetView<GuideSaveSeedPhraseStep3Controller> {
  const _ItemSeedPhraseWidget({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.spaceSmall),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: AppSizes.spaceNormal,
            horizontal: AppSizes.spaceVerySmall),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColorTheme.focus,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall)),
        child: Text.rich(
          TextSpan(text: (index).toString() + ' .  ', children: [
            TextSpan(
              text: controller.seedPhrase[index - 1],
              style: AppTextTheme.bodyText1.copyWith(
                  color: AppColorTheme.black, fontWeight: FontWeight.w600),
            )
          ]),
          textAlign: TextAlign.center,
          style: AppTextTheme.bodyText1.copyWith(
              color: AppColorTheme.hover, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _DialogAnimationWidget extends StatefulWidget {
  const _DialogAnimationWidget({
    Key? key,
  }) : super(key: key);

  @override
  _DialogAnimationWidgetState createState() => _DialogAnimationWidgetState();
}

class _DialogAnimationWidgetState extends State<_DialogAnimationWidget>
    with SingleTickerProviderStateMixin {
  late final GuideSaveSeedPhraseStep3Controller controller;
  @override
  void initState() {
    controller = Get.find<GuideSaveSeedPhraseStep3Controller>();

    controller.animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
      value: 1.0,
    );

    super.initState();
  }

  @override
  void dispose() {
    controller.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0.0,
      bottom: 0.0,
      right: 0.0,
      left: 0.0,
      child: FadeTransition(
        opacity: CurvedAnimation(
            parent: controller.animationController, curve: Curves.easeInExpo),
        child: _DialogWidget(),
      ),
    );
  }
}

class _DialogWidget extends GetView<GuideSaveSeedPhraseStep3Controller> {
  const _DialogWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: Container(
          padding: EdgeInsets.all(AppSizes.spaceLarge),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
              color: AppColorTheme.canvas),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'guildWallet_step3_showCode'.tr,
                style: AppTextTheme.bodyText1
                    .copyWith(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              Text(
                'guildWallet_step_spy'.tr,
                textAlign: TextAlign.center,
                style:
                    AppTextTheme.bodyText2.copyWith(color: AppColorTheme.hover),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  controller.handleButtonSeenOnTap();
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppSizes.spaceVeryLarge),
                  height: AppSizes.sizeButtonWidget.height - 16.0,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: AppColorTheme.canvas, blurRadius: 8.0)
                    ],
                    color: AppColorTheme.white,
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadiusVeryLarge),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        controller.icEyeVisible,
                        color: AppColorTheme.textAccent,
                      ),
                      SizedBox(
                        width: AppSizes.spaceSmall,
                      ),
                      Text(
                        'guildWallet_step3_seen'.tr,
                        style: AppTextTheme.bodyText1.copyWith(
                            color: AppColorTheme.textAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
