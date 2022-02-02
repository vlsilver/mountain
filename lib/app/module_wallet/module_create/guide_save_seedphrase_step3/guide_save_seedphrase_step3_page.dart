import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_wallet/module_create/widget/btn_widget.dart';
import 'package:base_source/app/module_wallet/module_create/widget/indicator_widget.dart';
import 'package:base_source/app/widget_global/global_app_bar_widget.dart';
import 'package:base_source/app/widget_global/global_layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'guide_save_seedphrase_step3_controller.dart';
import 'widget/show_sheed_phare_widget.dart';

class GuideSaveSeedPhraseStep3Page
    extends GetView<GuideSaveSeedPhraseStep3Controller> {
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
                  ShowSheedPhraseWidget(),
                  Expanded(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: AppSizes.spaceLarge),
                    ),
                  ),
                  GetBuilder<GuideSaveSeedPhraseStep3Controller>(
                      builder: (_) => ButtonWidget(
                          name: 'global_btn_continue'.tr,
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
