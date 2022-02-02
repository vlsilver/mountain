import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_wallet/module_create/widget/btn_widget.dart';
import 'package:base_source/app/module_wallet/module_create/widget/indicator_widget.dart';

import 'package:base_source/app/widget_global/global_layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'guide_save_seedphrase_controller.dart';
import 'widget/comple_widget.dart';

class GuideSaveSeedPhraseCompletePage
    extends GetView<GuideSaveSeedPhraseCompleteController> {
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
          Expanded(
            child: GlobalLayoutBuilderWidget(
              padding:
                  EdgeInsets.symmetric(horizontal: AppSizes.spaceVeryLarge),
              child: Column(
                children: [
                  CompleteWidget(),
                  Expanded(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: AppSizes.spaceLarge),
                    ),
                  ),
                  ButtonWidget(
                      name: 'guildWallet_complete_finish'.tr,
                      onTap: () {
                        controller.handleButtonOnTap();
                      }),
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
