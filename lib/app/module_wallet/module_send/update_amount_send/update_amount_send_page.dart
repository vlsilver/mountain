import 'dart:math';

import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:base_source/app/widget_global/global_avatar_coin_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'update_amount_send_controller.dart';

class UpdateAmountSendPage extends GetView<UpdateAmountSendController> {
  const UpdateAmountSendPage({
    Key? key,
    required this.isFullScreen,
  }) : super(key: key);

  final bool isFullScreen;
  @override
  Widget build(BuildContext context) {
    controller.isFullScreen = isFullScreen;
    return Scaffold(
      appBar: isFullScreen ? _buildAppBar() : null,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColorTheme.focus,
      body: InkWell(
        focusNode: controller.focusNode,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          controller.focusNode.unfocus();
        },
        child: Column(
          children: [
            !isFullScreen
                ? const SizedBox(height: AppSizes.spaceNormal)
                : const SizedBox(),
            !isFullScreen
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spaceLarge),
                    child: AppBarWidget(
                        title: 'global_amount'.tr,
                        onTap: controller.handleIcbackOnTap),
                  )
                : const SizedBox(),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: controller.calculatorsStr
                          .map((element) =>
                              _CalculatorAmountWidget(title: element))
                          .toList(),
                    ),
                    _InputAmountWidget(),
                    _GroupCompareAmountWidget(),
                    Expanded(child: SizedBox()),
                    GetBuilder<UpdateAmountSendController>(
                      id: EnumUpdateSendInputAmount.BUTTON,
                      builder: (_) {
                        return GlobalButtonWidget(
                            name: 'global_btn_continue'.tr,
                            type: _.isActiveButton
                                ? ButtonType.ACTIVE
                                : ButtonType.DISABLE,
                            onTap: _.handleButtonContinueOnTap);
                      },
                    )
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

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        splashRadius: AppSizes.spaceMedium,
        iconSize: 24.0,
        onPressed: () {
          controller.handleIcbackOnTap();
        },
        icon: Icon(
          Icons.arrow_back_ios_new_outlined,
          size: 24.0,
          color: AppColorTheme.white,
        ),
      ),
      backgroundColor: AppColorTheme.appBarAccent,
      title: Text(
        'global_amount'.tr,
        style: AppTextTheme.titleAppbar,
      ),
    );
  }
}

class _CalculatorAmountWidget extends GetView<UpdateAmountSendController> {
  const _CalculatorAmountWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        controller.handleTextSetAmountOnTap(title);
      },
      borderRadius: BorderRadius.circular(4.0),
      minSize: 32,
      color: AppColorTheme.card,
      padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceSmall),
      child: Text(
        title,
        style: AppTextTheme.bodyText1.copyWith(
          color: AppColorTheme.highlight,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _GroupCompareAmountWidget extends GetView<UpdateAmountSendController> {
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
              textAlign: TextAlign.right,
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

class _InputAmountWidget extends StatelessWidget {
  const _InputAmountWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: GetBuilder<UpdateAmountSendController>(
            id: EnumUpdateSendInputAmount.BUTTON,
            builder: (_) {
              return TextFormField(
                controller: _.amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                onTap: () {},
                style: !_.isErrorInputAmount
                    ? AppTextTheme.number1
                    : AppTextTheme.number1.copyWith(color: AppColorTheme.error),
                textAlignVertical: TextAlignVertical.center,
                maxLines: 1,
                decoration: InputDecoration(
                  hintStyle: AppTextTheme.number1,
                  hintText: '0',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadiusSmall),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GroupValueAddressWidget extends GetView<UpdateAmountSendController> {
  const _GroupValueAddressWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: controller.handleCoinBoxOnTap,
      padding: EdgeInsets.zero,
      child: GetBuilder<UpdateAmountSendController>(
        id: EnumUpdateSendInputAmount.COIN,
        builder: (_) {
          return Container(
            padding: EdgeInsets.symmetric(
                vertical: AppSizes.spaceMedium,
                horizontal: AppSizes.spaceSmall),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.spaceSmall),
                color: AppColorTheme.card),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 56.0,
                    width: 56.0,
                    padding: EdgeInsets.all(AppSizes.spaceSmall),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppColorTheme.focus),
                    child: GlobalAvatarCoinWidget(
                        coinModel: _.sendController.coinModelSelect)),
                SizedBox(width: AppSizes.spaceNormal),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _.sendController.coinModelSelect.name,
                          style: AppTextTheme.bodyText1.copyWith(
                              color: AppColorTheme.accent,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: AppSizes.spaceMedium),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                    GetBuilder<WalletController>(
                      id: EnumUpdateWallet.CURRENCY_ACTIVE,
                      builder: (walletController) {
                        return Row(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                  minWidth: 0, maxWidth: Get.width / 2 - 32),
                              child: Text(
                                _.sendController.coinModelSelect
                                    .valueNoRoundBrackets,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextTheme.bodyText1.copyWith(
                                    color: AppColorTheme.black60,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  minWidth: 0, maxWidth: Get.width / 2 - 100.0),
                              child: Text(
                                controller.sendController.coinModelSelect
                                    .currencyWithRoundBracks,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextTheme.bodyText1
                                    .copyWith(color: AppColorTheme.black60),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
