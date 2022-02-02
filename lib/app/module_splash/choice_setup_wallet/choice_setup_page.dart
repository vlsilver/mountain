import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:base_source/app/widget_global/global_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'choice_setup_controller.dart';
import 'widget/bg_widget.dart';

class ChoiceSetupPage extends GetView<ChoiceSetupController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SetupWalletBackgroundWidget(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: 0.0,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppSizes.spaceVeryLarge),
                GlobalLogoWidget(height: 72.0, type: 1),
                SizedBox(height: AppSizes.spaceNormal),
                Text(
                  controller.titleStr,
                  textAlign: TextAlign.center,
                  style: AppTextTheme.headline1,
                ),
                SizedBox(height: AppSizes.spaceSmall),
                Text(
                  controller.descStr,
                  textAlign: TextAlign.center,
                  style: AppTextTheme.bodyText1,
                ),
                Expanded(
                  child: SizedBox(),
                ),
                GlobalButtonWidget(
                    name: controller.btnImportStr,
                    type: ButtonType.NORMAL,
                    onTap: () {
                      controller.handleButtonImportMnemonicOnTap();
                    }),
                SizedBox(height: AppSizes.spaceMedium),
                GlobalButtonWidget(
                    name: controller.btnNewStr,
                    type: ButtonType.ACTIVE,
                    onTap: () {
                      controller.handleButtonCreateNewWalletOnTap();
                    }),
                SizedBox(height: AppSizes.spaceMedium),
                RichText(
                  text: TextSpan(
                      text: controller.privacy1Str,
                      style: AppTextTheme.caption
                          .copyWith(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: controller.privacy2Str,
                          recognizer: controller.handleTextRecognize,
                          style: AppTextTheme.caption.copyWith(
                              decoration: TextDecoration.underline,
                              color: AppColorTheme.textAccent),
                        )
                      ]),
                ),
                SizedBox(height: AppSizes.spaceMax),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
