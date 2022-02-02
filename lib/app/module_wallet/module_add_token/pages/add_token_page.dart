import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/asset_values.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:base_source/app/module_wallet/widget/input_widget.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../add_token_controller.dart';

class AddTokenPage extends GetView<AddTokenController> {
  const AddTokenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlobalBottomSheetLayoutWidget(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusNode: controller.focusNode,
        onTap: () {
          controller.focusNode.unfocus();
        },
        child: Column(
          children: [
            SizedBox(height: AppSizes.spaceSmall),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
              child: AppBarWidget(
                  title: 'add_new_token'.tr,
                  onTap: controller.handleIcBackLocalOnTap),
            ),
            SizedBox(height: AppSizes.spaceMedium),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
                child: Column(
                  children: [
                    CupertinoButton(
                      onPressed: controller.handleBlockChainBoxOnTap,
                      padding: EdgeInsets.zero,
                      child: Container(
                        height: 56.0,
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.spaceMedium),
                        decoration: BoxDecoration(
                            color: AppColorTheme.card,
                            borderRadius:
                                BorderRadius.circular(AppSizes.spaceSmall)),
                        child: Center(
                          child: Row(
                            children: [
                              Expanded(
                                child: GetBuilder<AddTokenController>(
                                  id: EnumAddToken.BLOCK_CHAIN,
                                  builder: (_) {
                                    return Text(
                                      _.blockChainModelActive.network,
                                      style: AppTextTheme.bodyText1.copyWith(
                                          color: AppColorTheme.accent,
                                          fontWeight: FontWeight.w600),
                                    );
                                  },
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 32.0,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.spaceSmall),
                    Stack(
                      children: [
                        InputWidget(
                            controller: controller.addressController,
                            onTap: () {},
                            hintText: 'enter_contract_address'.tr),
                        Positioned(
                          right: 4.0,
                          top: 0.0,
                          bottom: 0.0,
                          child: GetBuilder<AddTokenController>(
                            id: EnumAddToken.INPUT_ADDRESS,
                            builder: (_) {
                              return IconButton(
                                splashRadius: AppSizes.borderRadiusSmall,
                                onPressed: () {
                                  !controller.isActiveButton
                                      ? controller.handleIconQRScanOnTap()
                                      : controller.handleIcCloseOnTap();
                                },
                                icon: !controller.isActiveButton
                                    ? SvgPicture.asset(
                                        AppAssets.globalIcScan,
                                        color: AppColorTheme.black,
                                      )
                                    : Icon(Icons.close,
                                        color: AppColorTheme.black),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: SizedBox(height: AppSizes.spaceMedium)),
                    GetBuilder<AddTokenController>(
                      id: EnumAddToken.BUTTON,
                      builder: (_) {
                        return GlobalButtonWidget(
                            name: 'global_add'.tr,
                            type: _.isActiveButton
                                ? ButtonType.ACTIVE
                                : ButtonType.DISABLE,
                            onTap: controller.handleButtonAddOnTap);
                      },
                    ),
                    SizedBox(height: AppSizes.spaceVeryLarge)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
