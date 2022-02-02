import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../guide_save_seedphrase_setp1_controller.dart';

class DialogSkipSecurityWidget
    extends GetView<GuideSaveSeedPhraseStep1Controller> {
  const DialogSkipSecurityWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceLarge),
        child: Material(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
          color: AppColorTheme.focus,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppSizes.spaceSmall,
                    right: AppSizes.spaceSmall,
                  ),
                  child: SizedBox(
                    height: 32.0,
                    width: 32.0,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      iconSize: 32.0,
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.close),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.spaceLarge),
                child: Column(
                  children: [
                    Text(
                      'guildWallet_skipTour'.tr,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.headline2.copyWith(
                          color: AppColorTheme.error,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: AppSizes.spaceLarge),
                    Text(
                      'guildWalletIfLost'.tr,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.bodyText1
                          .copyWith(color: AppColorTheme.black60),
                    ),
                    SizedBox(height: AppSizes.spaceLarge),
                    GlobalButtonWidget(
                        name: 'guildWallet_skip'.tr,
                        type: ButtonType.ERROR,
                        onTap: () {
                          controller.handleButtonSkipOnTap();
                        }),
                    SizedBox(height: AppSizes.spaceLarge),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
