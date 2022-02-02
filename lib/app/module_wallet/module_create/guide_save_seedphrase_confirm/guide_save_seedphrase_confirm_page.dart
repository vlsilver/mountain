import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_wallet/module_create/widget/btn_widget.dart';
import 'package:base_source/app/module_wallet/module_create/widget/indicator_widget.dart';
import 'package:base_source/app/widget_global/global_app_bar_widget.dart';

import 'package:base_source/app/widget_global/global_layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'guide_save_seedphrase_confirm_controller.dart';
import 'widget/confirm_sheed_phare_widget.dart';

class GuideSaveSeedPhraseConfirmPage
    extends GetView<GuideSaveSeedPhraseConfirmController> {
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
          GlobalAppbarWiget(
            onTap: controller.handleButtonBackAppBarOnTap,
          ),
          GroupIndicatorWidget(),
          Expanded(
            child: GlobalLayoutBuilderWidget(
              padding:
                  EdgeInsets.symmetric(horizontal: AppSizes.spaceVeryLarge),
              child: Column(
                children: [
                  ConfirmSheedPhraseWidget(),
                  Expanded(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: AppSizes.spaceLarge),
                    ),
                  ),
                  GetBuilder<GuideSaveSeedPhraseConfirmController>(
                      id: EnumUpdateGuideSaveSeedPhraseConfirm.BUTTON,
                      builder: (_) => ButtonWidget(
                          name: _.isCompletedStep
                              ? 'guildWallet_confirm_step1'.tr
                              : 'global_btn_continue'.tr,
                          active: controller.isActiveButton,
                          onTap: () {
                            controller.handleButtonOnTap();
                          })),
                  SizedBox(
                    height: AppSizes.spaceVeryLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
