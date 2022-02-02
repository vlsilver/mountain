import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/widget_global/global_app_bar_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:base_source/app/widget_global/global_layout_builder_widget.dart';
import 'package:base_source/app/widget_global/global_switch_touchId_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'import_wallet_controller.dart';
import 'widget/form_input_widget.dart';
import 'widget/privacy_widget.dart';

class ImportWalletPage extends GetView<ImportWalletController> {
  const ImportWalletPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 0.0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: InkWell(
        focusNode: controller.focusNode,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          controller.handleScreenOnTap();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GlobalAppbarWiget(
              onTap: controller.handleButtonBackAppBarOnTap,
            ),
            Expanded(
              child: GlobalLayoutBuilderWidget(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceVeryLarge,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'import_root'.tr,
                        textAlign: TextAlign.center,
                        style: AppTextTheme.headline2
                            .copyWith(color: AppColorTheme.accent),
                      ),
                      SizedBox(height: AppSizes.spaceNormal),
                      Text(
                        'create_root'.tr,
                        textAlign: TextAlign.center,
                        style: AppTextTheme.bodyText1
                            .copyWith(color: AppColorTheme.black50),
                      ),
                      SizedBox(height: AppSizes.spaceVeryLarge),
                      ImportWalletFormInputWidget(),
                      SizedBox(
                        height: AppSizes.spaceMedium,
                      ),
                      GetBuilder<ImportWalletController>(
                        id: EnumUpdateImportWallet.SWITCH_TOUCH_ID,
                        builder: (_) {
                          return GlobalSwitchTouchIdWidget(
                            value: _.isEnableTouchId,
                            onChange: _.handleSwitchTouchIdOnChange,
                          );
                        },
                      ),
                      Expanded(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: AppSizes.spaceLarge),
                        ),
                      ),
                      GetBuilder<ImportWalletController>(
                          id: EnumUpdateImportWallet.BUTTON,
                          builder: (_) => GlobalButtonWidget(
                              name: 'global_import'.tr,
                              type: controller.isActiveButton
                                  ? ButtonType.ACTIVE
                                  : ButtonType.DISABLE,
                              onTap: () {
                                controller.handleButtonOnTap();
                              })),
                      SizedBox(
                        height: AppSizes.spaceMedium,
                      ),
                      PrivacyWidget(),
                      SizedBox(
                        height: AppSizes.spaceVeryLarge,
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
