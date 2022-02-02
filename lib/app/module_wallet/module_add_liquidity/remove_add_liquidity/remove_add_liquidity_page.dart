import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:base_source/app/widget_global/global_avatar_coin_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:base_source/app/widget_global/global_layout_builder_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'remove_add_liquidity_controller.dart';

class RemoveAddLiquidityPage extends GetView<RemoveAddLiquidityController> {
  const RemoveAddLiquidityPage({
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMedium),
          child: GlobalLayoutBuilderWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                !isFullScreen
                    ? const SizedBox(height: AppSizes.spaceNormal)
                    : const SizedBox(),
                !isFullScreen
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.spaceSmall),
                        child: AppBarWidget(
                            title: 'add_liquidity_remove_confirm'.tr,
                            onTap: () {
                              controller.handleIconBackOnTap();
                            }),
                      )
                    : const SizedBox(),
                const SizedBox(height: AppSizes.spaceMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColorTheme.backGround2,
                      ),
                      child: GlobalAvatarCoinWidget(
                        coinModel: controller.addLiquidityModel.tokenA,
                        height: 32.0,
                        width: 32.0,
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceSmall),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColorTheme.backGround2,
                      ),
                      child: GlobalAvatarCoinWidget(
                        coinModel: controller.addLiquidityModel.tokenB,
                        height: 32.0,
                        width: 32.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceSmall),
                Column(
                  children: [
                    Text(
                      'add_liquidity_your_lp_token'.tr,
                      style: AppTextTheme.bodyText1
                          .copyWith(color: AppColorTheme.black),
                    ),
                    const SizedBox(height: AppSizes.spaceVerySmall),
                    Text(
                        controller
                            .addLiquidityModel.tokenLP.valueWithSymbolString,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextTheme.body
                            .copyWith(color: AppColorTheme.textAction))
                  ],
                ),
                const SizedBox(height: AppSizes.spaceLarge),
                const _GroupAmountWidget(),
                const SizedBox(height: AppSizes.spaceMedium),
                const Expanded(child: SizedBox(height: AppSizes.spaceLarge)),
                GetBuilder<RemoveAddLiquidityController>(
                  id: EnumRemoveAddLiquidity.BUTTON,
                  builder: (_) {
                    return Column(
                      children: [
                        GlobalButtonWidget(
                            name: 'global_approve'.tr,
                            type: _.isActiveButton && !_.isApproveSuccess
                                ? ButtonType.ACTIVE
                                : ButtonType.DISABLE,
                            onTap: _.handleButtonContinueOnTap),
                        const SizedBox(height: AppSizes.spaceNormal),
                        GlobalButtonWidget(
                            name: 'add_liquidity_remove'.tr,
                            type: _.isApproveSuccess && _.isActiveButton
                                ? ButtonType.ACTIVE
                                : ButtonType.DISABLE,
                            onTap: _.handleButtonContinueOnTap),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSizes.spaceVeryLarge),
              ],
            ),
          ),
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
          controller.handleIconBackOnTap();
        },
        icon: Icon(
          Icons.arrow_back_ios_new_outlined,
          size: 24.0,
          color: AppColorTheme.white,
        ),
      ),
      backgroundColor: AppColorTheme.appBarAccent,
      title: Text(
        'add_liquidity_remove_confirm'.tr,
        style: AppTextTheme.titleAppbar,
      ),
    );
  }
}

class _GroupAmountWidget extends GetView<RemoveAddLiquidityController> {
  const _GroupAmountWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceNormal, vertical: AppSizes.spaceMedium),
      decoration: BoxDecoration(
          color: AppColorTheme.focus,
          borderRadius: BorderRadius.circular(AppSizes.spaceMedium),
          border: Border.all(color: AppColorTheme.textAction, width: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _GroupACaculatorWidget(),
          const SizedBox(height: AppSizes.spaceNormal),
          Row(
            children: [
              const _InputAmountAWidget(),
            ],
          ),
        ],
      ),
    );
  }
}

class _GroupACaculatorWidget extends GetView<RemoveAddLiquidityController> {
  const _GroupACaculatorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'add_liquidity_remove'.tr,
          style: AppTextTheme.bodyText2
              .copyWith(fontSize: 13.0, color: AppColorTheme.black),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: controller.calculatorsStr
                .map((element) => _CalculatorAmountWidget(
                      title: element,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _CalculatorAmountWidget extends GetView<RemoveAddLiquidityController> {
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
      minSize: 0.0,
      padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceMedium),
      child: Text(
        title,
        style: AppTextTheme.bodyText2.copyWith(
          color: AppColorTheme.textAction,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InputAmountAWidget extends StatelessWidget {
  const _InputAmountAWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GetBuilder<RemoveAddLiquidityController>(
        id: EnumRemoveAddLiquidity.BUTTON,
        builder: (_) {
          return TextFormField(
            controller: _.amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.start,
            onTap: () {},
            style: !_.isErrorInputAmount
                ? AppTextTheme.number2
                : AppTextTheme.number2.copyWith(color: AppColorTheme.error),
            maxLines: 1,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              hintStyle: AppTextTheme.number2,
              hintText: '0.0',
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          );
        },
      ),
    );
  }
}
