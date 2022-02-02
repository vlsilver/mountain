import 'dart:math';

import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_wallet/module_request_receive/request_receive_controller.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:base_source/app/widget_global/global_avatar_coin_widget.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class InputAmountPage extends GetView<RequestRecieveController> {
  const InputAmountPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GlobalBottomSheetLayoutWidget(
      child: InkWell(
        focusNode: controller.focusNode,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: controller.handleScreenOnTap,
        child: Column(
          children: [
            SizedBox(height: AppSizes.spaceNormal),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
              child: AppBarWidget(
                  title: 'titleInputStr'.tr,
                  onTap: controller.handleIcBackOnTap),
            ),
            SizedBox(height: AppSizes.spaceVeryLarge),
            Flexible(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _GroupValueAddressWidget(),
                    SizedBox(height: AppSizes.spaceMedium),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _InputAmountWidget(),
                        // Expanded(
                        //   child: Text(
                        //     controller.coinModel.symbol,
                        //     style: AppTextTheme.number1
                        //         .copyWith(color: AppColorTheme.black),
                        //   ),
                        // )
                      ],
                    ),
                    SizedBox(height: AppSizes.spaceMedium),
                    _GroupCompareAmountWidget(),
                    Expanded(child: SizedBox()),
                    _GroupShowErrorWidget(),
                    SizedBox(height: AppSizes.spaceSmall),
                    GlobalButtonWidget(
                        name: 'btnContinueStr'.tr,
                        type: ButtonType.ACTIVE,
                        onTap: controller.handleButtonContinueOnTap),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: AppSizes.spaceVeryLarge,
            )
          ],
        ),
      ),
    );
  }
}

class _GroupCompareAmountWidget extends GetView<RequestRecieveController> {
  const _GroupCompareAmountWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.rotate(
          angle: pi / 2,
          child: Icon(
            Icons.compare_arrows_outlined,
            color: AppColorTheme.accent,
          ),
        ),
        Obx(
          () => Flexible(
            child: Text(
              controller.currencyCompare,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black),
            ),
          ),
        )
      ],
    );
  }
}

class _InputAmountWidget extends GetView<RequestRecieveController> {
  const _InputAmountWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextFormField(
        controller: controller.amountController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        onTap: controller.handleAmountInputOntap,
        style: AppTextTheme.number1,
        textAlignVertical: TextAlignVertical.center,
        maxLines: 1,
        decoration: InputDecoration(
          isDense: true,
          isCollapsed: true,
          hintStyle: AppTextTheme.number1,
          hintText: '0',
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
          ),
        ),
      ),
    );
  }
}

class _GroupValueAddressWidget extends GetView<RequestRecieveController> {
  const _GroupValueAddressWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: AppSizes.spaceMedium, horizontal: AppSizes.spaceSmall),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.spaceSmall),
          color: AppColorTheme.card),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 52.0,
              width: 52.0,
              padding: EdgeInsets.all(AppSizes.spaceSmall),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: AppColorTheme.focus),
              child: GlobalAvatarCoinWidget(coinModel: controller.coinModel)),
          SizedBox(width: AppSizes.spaceNormal),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.coinModel.name,
                style: AppTextTheme.bodyText1.copyWith(
                    color: AppColorTheme.accent, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Container(
                    constraints: BoxConstraints(
                        minWidth: 0, maxWidth: Get.width / 2 - 32),
                    child: Text(
                      controller.coinModel.valueNoRoundBrackets,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.bodyText1.copyWith(
                          color: AppColorTheme.black60,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        minWidth: 0, maxWidth: Get.width / 2 - 100),
                    child: Text(
                      controller.coinModel.currencyWithRoundBracks,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.bodyText1
                          .copyWith(color: AppColorTheme.black60),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GroupShowErrorWidget extends GetView<RequestRecieveController> {
  const _GroupShowErrorWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestRecieveController>(
      id: EnumRequestReceive.AMOUNT,
      builder: (_) {
        return Visibility(
          visible: _.isErrorAmount,
          child: Container(
            margin: EdgeInsets.only(bottom: AppSizes.spaceSmall),
            padding: EdgeInsets.all(AppSizes.spaceMedium),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
                color: AppColorTheme.highlight20),
            child: Text(
              'error_amount_format'.tr,
              style:
                  AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black),
            ),
          ),
        );
      },
    );
  }
}
