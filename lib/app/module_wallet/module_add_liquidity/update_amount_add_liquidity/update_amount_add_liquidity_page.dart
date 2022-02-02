import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/add_liquidity_controller.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/widget_global/global_avatar_coin_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:base_source/app/widget_global/global_layout_builder_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'update_amount_add_liquidity_controller.dart';

class UpdateAmountAddLiquidityPage
    extends GetView<UpdateAmountAddLiquidityController> {
  const UpdateAmountAddLiquidityPage({
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                !isFullScreen
                    ? const SizedBox(height: AppSizes.spaceNormal)
                    : const SizedBox(),
                !isFullScreen
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.spaceSmall),
                        child: AppBarWidget(
                            title: 'global_amount'.tr,
                            onTap: () {
                              controller.handleIconBackOnTap();
                            }),
                      )
                    : const SizedBox(),
                const SizedBox(height: AppSizes.spaceMedium),
                Stack(
                  children: [
                    Column(
                      children: [
                        const _GroupAWidget(),
                        const SizedBox(height: AppSizes.spaceLarge),
                        const _GroupBWidget(),
                      ],
                    ),
                    const _ConvertWidget(),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceMedium),
                const _GroupPricesWidget(),
                const Expanded(child: SizedBox(height: AppSizes.spaceLarge)),
                GetBuilder<UpdateAmountAddLiquidityController>(
                  id: EnumUpdateInputAmountAddLiquidity.BUTTON,
                  builder: (_) {
                    if (_.isApprove) {
                      return Column(
                        children: [
                          GlobalButtonWidget(
                              name: 'global_approve'.tr,
                              type: _.isActiveButton &&
                                      !_.isApproveSuccess &&
                                      _.isApprove
                                  ? ButtonType.ACTIVE
                                  : ButtonType.DISABLE,
                              onTap: _.handleButtonContinueOnTap),
                          const SizedBox(height: AppSizes.spaceNormal),
                          GlobalButtonWidget(
                              name: 'global_supply'.tr,
                              type: _.isApproveSuccess && _.isActiveButton
                                  ? ButtonType.ACTIVE
                                  : ButtonType.DISABLE,
                              onTap: _.handleButtonContinueOnTap),
                        ],
                      );
                    }

                    return GlobalButtonWidget(
                        name: 'global_supply'.tr,
                        type: _.isActiveButton
                            ? ButtonType.ACTIVE
                            : ButtonType.DISABLE,
                        onTap: _.handleButtonContinueOnTap);
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
        'global_amount'.tr,
        style: AppTextTheme.titleAppbar,
      ),
    );
  }
}

class _GroupPricesWidget extends StatelessWidget {
  const _GroupPricesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('add_liquidity_prices'.tr.toUpperCase(),
            style: AppTextTheme.body.copyWith(
                color: AppColorTheme.black, fontWeight: FontWeight.w500)),
        const SizedBox(height: AppSizes.spaceSmall),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceNormal, vertical: AppSizes.spaceMedium),
          decoration: BoxDecoration(
              color: AppColorTheme.focus,
              borderRadius: BorderRadius.circular(AppSizes.spaceMedium),
              border: Border.all(color: AppColorTheme.textAction, width: 0.5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetBuilder<AddLiquidityController>(
                id: EnumAddLiquidity.RATE,
                builder: (_) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  Crypto.numberFormatNumberTokenRate(_.rate),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: AppTextTheme.bodyText2.copyWith(
                                      color: AppColorTheme.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  'add_liquidity_per'.trParams({
                                    'symbolFrom': _.coinModelB.symbol,
                                    'symbolTo': _.coinModelA.symbol
                                  })!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: AppTextTheme.bodyText2.copyWith(
                                    color: AppColorTheme.black50,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  _.rate == 0.0
                                      ? '0.0'
                                      : Crypto.numberFormatNumberTokenRate(
                                          1 / _.rate),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: AppTextTheme.bodyText2.copyWith(
                                      color: AppColorTheme.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  'add_liquidity_per'.trParams({
                                    'symbolTo': _.coinModelB.symbol,
                                    'symbolFrom': _.coinModelA.symbol
                                  })!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: AppTextTheme.bodyText2.copyWith(
                                    color: AppColorTheme.black50,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  _.formatShareOfPool,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: AppTextTheme.bodyText2.copyWith(
                                      color: AppColorTheme.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  'add_liquidity_share_of_pool'.tr,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: AppTextTheme.bodyText2.copyWith(
                                    color: AppColorTheme.black50,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      _.isErroRate && _.isLoadRate
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  top: AppSizes.spaceSmall),
                              child: Text('unable_to_calculate'.tr,
                                  style: AppTextTheme.bodyText2
                                      .copyWith(color: AppColorTheme.error)),
                            )
                          : SizedBox()
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _ConvertWidget extends StatelessWidget {
  const _ConvertWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Center(
        child: Container(
          height: 36.0,
          width: 64.0,
          padding:
              const EdgeInsets.symmetric(vertical: AppSizes.spaceVerySmall),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.spaceSmall),
              color: AppColorTheme.card),
          child: Icon(
            Icons.add_outlined,
            color: AppColorTheme.black,
          ),
        ),
      ),
    );
  }
}

class _GroupAWidget extends StatelessWidget {
  const _GroupAWidget({
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
          const _GroupACaculatorWidget(isFrom: true),
          const SizedBox(height: AppSizes.spaceNormal),
          Row(
            children: [
              const _InputAmountAWidget(),
              const SizedBox(width: AppSizes.spaceNormal),
              const _GroupCoinAWidget(),
            ],
          ),
          const SizedBox(height: AppSizes.spaceSmall),
          const _GroupCompareCurrencyAWidget()
        ],
      ),
    );
  }
}

class _GroupBWidget extends GetView<UpdateAmountAddLiquidityController> {
  const _GroupBWidget({
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
          const _GroupACaculatorWidget(isFrom: false),
          const SizedBox(height: AppSizes.spaceNormal),
          Row(
            children: [
              const _InputAmountBWidget(),
              const SizedBox(width: AppSizes.spaceNormal),
              const _GroupCoinBWidget(),
            ],
          ),
          const SizedBox(height: AppSizes.spaceSmall),
          const _GroupCompareCurrencyBWidget()
        ],
      ),
    );
  }
}

class _GroupACaculatorWidget
    extends GetView<UpdateAmountAddLiquidityController> {
  const _GroupACaculatorWidget({
    Key? key,
    required this.isFrom,
  }) : super(key: key);

  final bool isFrom;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'global_from'.tr,
          style: AppTextTheme.bodyText2
              .copyWith(fontSize: 13.0, color: AppColorTheme.black),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: controller.calculatorsStr
                .map((element) => _CalculatorAmountWidget(
                      title: element,
                      isFrom: isFrom,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _GroupCoinAWidget extends GetView<UpdateAmountAddLiquidityController> {
  const _GroupCoinAWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        controller.handleCoinBoxOnTap(true);
      },
      padding: EdgeInsets.zero,
      minSize: 0.0,
      child: GetBuilder<AddLiquidityController>(
        id: EnumAddLiquidity.RATE,
        builder: (_) {
          return _.coinModelA.id.isEmpty
              ? Container(
                  height: 40.0,
                  child: Row(
                    children: [
                      Text('select_currency'.tr,
                          style: AppTextTheme.bodyText2.copyWith(
                              color: AppColorTheme.black,
                              fontWeight: FontWeight.w500)),
                      const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 24.0,
                        color: AppColorTheme.black60,
                      ),
                    ],
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: AppColorTheme.card),
                      padding: const EdgeInsets.all(8.0),
                      child: GlobalAvatarCoinWidget(
                        height: 24.0,
                        width: 24.0,
                        coinModel: _.coinModelA,
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceSmall),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxWidth: Get.width / 3),
                              child: Text(
                                _.coinModelA.symbol,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextTheme.bodyText1.copyWith(
                                    color: AppColorTheme.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(width: AppSizes.spaceSmall),
                            const Icon(
                              Icons.keyboard_arrow_down_outlined,
                              size: 32.0,
                              color: AppColorTheme.black,
                            ),
                          ],
                        ),
                        Text(
                          '(' +
                              Crypto.numberFormatNumberTokenRate(
                                  _.coinModelA.amount) +
                              ')',
                          style: AppTextTheme.bodyText2
                              .copyWith(color: AppColorTheme.black60),
                        ),
                      ],
                    ),
                  ],
                );
        },
      ),
    );
  }
}

class _GroupCoinBWidget extends GetView<UpdateAmountAddLiquidityController> {
  const _GroupCoinBWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        controller.handleCoinBoxOnTap(false);
      },
      padding: EdgeInsets.zero,
      minSize: 0.0,
      child: GetBuilder<AddLiquidityController>(
        id: EnumAddLiquidity.RATE,
        builder: (_) {
          return _.coinModelB.id.isEmpty
              ? Container(
                  height: 40.0,
                  child: Row(
                    children: [
                      Text('select_currency'.tr,
                          style: AppTextTheme.bodyText2.copyWith(
                              color: AppColorTheme.black,
                              fontWeight: FontWeight.w500)),
                      const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 24.0,
                        color: AppColorTheme.black60,
                      ),
                    ],
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: AppColorTheme.card),
                      padding: const EdgeInsets.all(8.0),
                      child: GlobalAvatarCoinWidget(
                          height: 24.0, width: 24.0, coinModel: _.coinModelB),
                    ),
                    const SizedBox(width: AppSizes.spaceSmall),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxWidth: Get.width / 3),
                              child: Text(
                                _.coinModelB.symbol,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextTheme.bodyText1.copyWith(
                                    color: AppColorTheme.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(width: AppSizes.spaceSmall),
                            const Icon(
                              Icons.keyboard_arrow_down_outlined,
                              size: 32.0,
                              color: AppColorTheme.black,
                            ),
                          ],
                        ),
                        Text(
                          '(' +
                              Crypto.numberFormatNumberTokenRate(
                                  _.coinModelB.amount) +
                              ')',
                          style: AppTextTheme.bodyText2
                              .copyWith(color: AppColorTheme.black60),
                        ),
                      ],
                    ),
                  ],
                );
        },
      ),
    );
  }
}

class _CalculatorAmountWidget
    extends GetView<UpdateAmountAddLiquidityController> {
  const _CalculatorAmountWidget({
    Key? key,
    required this.title,
    required this.isFrom,
  }) : super(key: key);

  final String title;
  final bool isFrom;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        controller.handleTextSetAmountOnTap(title, isFrom);
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

class _GroupCompareCurrencyAWidget
    extends GetView<UpdateAmountAddLiquidityController> {
  const _GroupCompareCurrencyAWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddLiquidityController>(
      id: EnumAddLiquidity.RATE,
      builder: (_) {
        return GetBuilder<WalletController>(
          id: EnumUpdateWallet.CURRENCY_ACTIVE,
          builder: (walletController) {
            return Obx(
              () => Text(
                controller.currencyACompare,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextTheme.bodyText1
                    .copyWith(color: AppColorTheme.black60),
              ),
            );
          },
        );
      },
    );
  }
}

class _GroupCompareCurrencyBWidget
    extends GetView<UpdateAmountAddLiquidityController> {
  const _GroupCompareCurrencyBWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddLiquidityController>(
      id: EnumAddLiquidity.RATE,
      builder: (_) {
        return GetBuilder<WalletController>(
          id: EnumUpdateWallet.CURRENCY_ACTIVE,
          builder: (walletController) {
            return Obx(
              () => Text(
                controller.currencyBCompare,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextTheme.bodyText1
                    .copyWith(color: AppColorTheme.black60),
              ),
            );
          },
        );
      },
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
      child: GetBuilder<UpdateAmountAddLiquidityController>(
        id: EnumUpdateInputAmountAddLiquidity.BUTTON,
        builder: (_) {
          return TextFormField(
            controller: _.amountInAController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.start,
            onTap: () {
              _.isEditAmountB = false;
              _.isEditAmountA = true;
            },
            style: !_.isErrorInputAAmount
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

class _InputAmountBWidget extends StatelessWidget {
  const _InputAmountBWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GetBuilder<UpdateAmountAddLiquidityController>(
        id: EnumUpdateInputAmountAddLiquidity.BUTTON,
        builder: (_) {
          return TextFormField(
            controller: _.amountInBController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.start,
            onTap: () {
              _.isEditAmountB = true;
              _.isEditAmountA = false;
            },
            style: !_.isErrorInputBAmount
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
