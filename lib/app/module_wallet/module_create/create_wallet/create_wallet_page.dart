import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_wallet/module_create/widget/btn_widget.dart';
import 'package:base_source/app/module_wallet/module_create/widget/indicator_widget.dart';
import 'package:base_source/app/module_wallet/module_create/widget/title_widget.dart';
import 'package:base_source/app/widget_global/global_app_bar_widget.dart';
import 'package:base_source/app/widget_global/global_layout_builder_widget.dart';
import 'package:base_source/app/widget_global/global_switch_touchId_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'create_wallet_controller.dart';
import 'widget/form_input_widget.dart';
import 'widget/privacy_widget.dart';

class CreateWalletPage extends GetView<CreateWalletController> {
  const CreateWalletPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            GlobalAppbarWiget(onTap: controller.handleButtonBackAppBarOnTap),
            GroupIndicatorWidget(),
            SizedBox(height: AppSizes.spaceVeryLarge),
            Expanded(
              child: GlobalLayoutBuilderWidget(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceVeryLarge,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextTitleWidget(
                        title: 'create_password_title'.tr,
                      ),
                      SizedBox(height: AppSizes.spaceMedium),
                      Text(
                        'create_password_desc'.tr,
                        textAlign: TextAlign.center,
                        style: AppTextTheme.bodyText1
                            .copyWith(color: AppColorTheme.black50),
                      ),
                      SizedBox(height: AppSizes.spaceVeryLarge),
                      CreateWalletFormInputWidget(),
                      SizedBox(
                        height: AppSizes.spaceMedium,
                      ),
                      GetBuilder<CreateWalletController>(
                        id: EnumUpdateCreateWallet.SWITCH_TOUCH_ID,
                        builder: (_) {
                          return GlobalSwitchTouchIdWidget(
                            onChange: _.handleSwitchTouchIdOnChange,
                            value: _.isEnableTouchId,
                          );
                        },
                      ),
                      SizedBox(
                        height: AppSizes.spaceMedium,
                      ),
                      PrivacyWidget(),
                      Expanded(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: AppSizes.spaceLarge),
                        ),
                      ),
                      GetBuilder<CreateWalletController>(
                          id: EnumUpdateCreateWallet.BUTTON,
                          builder: (_) => ButtonWidget(
                              name: 'global_btn_continue'.tr,
                              active: controller.isActiveButton,
                              onTap: () {
                                controller.handleButtonOnTap();
                              })),
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
