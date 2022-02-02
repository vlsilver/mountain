import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_wallet/module_create/widget/btn_widget.dart';
import 'package:base_source/app/module_wallet/module_create/widget/indicator_widget.dart';
import 'package:base_source/app/widget_global/global_layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'guide_save_seedphrase_setp1_controller.dart';
import 'widget/explain_total_widget.dart';

class GuideSaveSeedPhraseStep1Page
    extends GetView<GuideSaveSeedPhraseStep1Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GroupIndicatorWidget(),
          SizedBox(height: AppSizes.spaceVeryLarge),
          Expanded(
            child: GlobalLayoutBuilderWidget(
              padding:
                  EdgeInsets.symmetric(horizontal: AppSizes.spaceVeryLarge),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SecureExplainTotalWidget(),
                  Expanded(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: AppSizes.spaceLarge),
                    ),
                  ),
                  ButtonWidget(
                    name: 'global_btn_start'.tr,
                    onTap: () {
                      controller.handleButtonOnTap();
                    },
                  ),
                  SizedBox(height: AppSizes.spaceNormal),
                  GestureDetector(
                    onTap: () {
                      controller.handleRemindTextOnTap();
                    },
                    child: Text(
                      'secure_remind'.tr,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.bodyText1.copyWith(
                        color: AppColorTheme.textAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceVeryLarge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
