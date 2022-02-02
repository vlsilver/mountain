import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:base_source/app/module_wallet/module_swap/swap_controller.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/widget_global/global_avatar_coin_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:base_source/app/widget_global/global_layout_builder_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'update_amount_swap_controller.dart';

class UpdateAmountSwapPage extends GetView<UpdateAmountSwapController> {
  const UpdateAmountSwapPage({
    Key? key,
    required this.isFullScreen,
    required this.isFast,
  }) : super(key: key);

  final bool isFullScreen;
  final bool isFast;

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
                              isFast
                                  ? Get.back()
                                  : controller.handleIconBackOnTap();
                            }),
                      )
                    : const SizedBox(),
                const SizedBox(height: AppSizes.spaceMedium),
                Stack(
                  children: [
                    Column(
                      children: [
                        const _GroupFromWidget(),
                        const SizedBox(height: AppSizes.spaceLarge),
                        const _GroupToWidget(),
                      ],
                    ),
                    const _ConvertWidget(),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceSmall),
                const _GroupCompareCoinValueWidget(),
                const Expanded(child: SizedBox(height: AppSizes.spaceLarge)),
                GetBuilder<UpdateAmountSwapController>(
                  id: EnumUpdateInputAmountSwap.BUTTON,
                  builder: (_) {
                    if (_.isApprove) {
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
                              name: 'global_swap'.tr,
                              type: _.isApproveSuccess && _.isActiveButton
                                  ? ButtonType.ACTIVE
                                  : ButtonType.DISABLE,
                              onTap: _.handleButtonContinueOnTap),
                        ],
                      );
                    }

                    return GlobalButtonWidget(
                        name: 'global_swap'.tr,
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
          isFast ? Get.back() : controller.handleIconBackOnTap();
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

class _GroupCompareCoinValueWidget extends GetView<UpdateAmountSwapController> {
  const _GroupCompareCoinValueWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SwapController>(
      id: EnumSwap.RATE,
      builder: (_) {
        return !_.isLoadRate
            ? SizedBox()
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '1 ' + _.coinModelFrom.symbol,
                        style: AppTextTheme.bodyText1.copyWith(
                            color: AppColorTheme.black80,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: AppSizes.spaceVerySmall),
                      SvgPicture.asset('assets/global/ic_equal.svg'),
                      const SizedBox(width: AppSizes.spaceVerySmall),
                      Text(
                        Crypto.numberFormatNumberTokenRate(_.rate) +
                            ' ' +
                            _.coinModelTo.symbol,
                        style: AppTextTheme.bodyText1.copyWith(
                            color: AppColorTheme.black80,
                            fontWeight: FontWeight.w600),
                      ),
                      GetBuilder<WalletController>(
                        id: EnumUpdateWallet.CURRENCY_ACTIVE,
                        builder: (walletController) {
                          return Text(
                            '(' + _.coinModelTo.ratePercentFormat + ')',
                            style: AppTextTheme.bodyText1.copyWith(
                                color: controller.swapController.coinModelTo
                                            .exchange <
                                        0.0
                                    ? AppColorTheme.error
                                    : AppColorTheme.toggleableActiveColor,
                                fontWeight: FontWeight.w600),
                          );
                        },
                      ),
                    ],
                  ),
                  _.isErroRate
                      ? Text('unable_to_calculate'.tr,
                          style: AppTextTheme.bodyText2
                              .copyWith(color: AppColorTheme.error))
                      : SizedBox()
                ],
              );
      },
    );
  }
}

class _ConvertWidget extends GetView<UpdateAmountSwapController> {
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
        child: CupertinoButton(
          onPressed: () {
            controller.handleChangePositionCoinModel();
          },
          padding: EdgeInsets.zero,
          minSize: 0.0,
          child: Container(
            height: 36.0,
            width: 64.0,
            padding:
                const EdgeInsets.symmetric(vertical: AppSizes.spaceVerySmall),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.spaceSmall),
                color: AppColorTheme.card),
            child: SvgPicture.asset(
              'assets/wallet/ic_convert.svg',
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupFromWidget extends StatelessWidget {
  const _GroupFromWidget({
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
          const _GroupFromCaculatorWidget(),
          const SizedBox(height: AppSizes.spaceNormal),
          Row(
            children: [
              const _InputAmountInWidget(),
              const SizedBox(width: AppSizes.spaceNormal),
              const _GoupCoinFromWidget(),
            ],
          ),
          const SizedBox(height: AppSizes.spaceSmall),
          const _GroupCompareCurrencyFromWidget()
        ],
      ),
    );
  }
}

class _GroupToWidget extends GetView<UpdateAmountSwapController> {
  const _GroupToWidget({
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
          Text(
            'global_to'.tr + ' ' + 'add_liquidity_estimate'.tr,
            style: AppTextTheme.bodyText2
                .copyWith(fontSize: 13.0, color: AppColorTheme.black),
          ),
          const SizedBox(height: AppSizes.spaceNormal),
          Row(
            children: [
              const _InputAmountOutWidget(),
              const SizedBox(width: AppSizes.spaceNormal),
              const _GoupCoinToWidget(),
            ],
          ),
          const SizedBox(height: AppSizes.spaceSmall),
          const _GroupCompareCurrencyToWidget()
        ],
      ),
    );
  }
}

class _GroupFromCaculatorWidget extends GetView<UpdateAmountSwapController> {
  const _GroupFromCaculatorWidget({
    Key? key,
  }) : super(key: key);

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
                .map((element) => _CalculatorAmountWidget(title: element))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _GoupCoinFromWidget extends GetView<UpdateAmountSwapController> {
  const _GoupCoinFromWidget({
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
      child: GetBuilder<SwapController>(
        id: EnumSwap.RATE,
        builder: (_) {
          return _.coinModelFrom.id.isEmpty
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
                          coinModel: _.coinModelFrom),
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
                                _.coinModelFrom.symbol,
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
                              size: 24.0,
                              color: AppColorTheme.black,
                            ),
                          ],
                        ),
                        Text(
                          '(' +
                              Crypto.numberFormatNumberTokenRate(
                                  _.coinModelFrom.amount) +
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

class _GoupCoinToWidget extends GetView<UpdateAmountSwapController> {
  const _GoupCoinToWidget({
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
      child: GetBuilder<SwapController>(
        id: EnumSwap.RATE,
        builder: (_) {
          return _.coinModelTo.id.isEmpty
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
                          height: 24.0, width: 24.0, coinModel: _.coinModelTo),
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
                                _.coinModelTo.symbol,
                                style: AppTextTheme.bodyText1.copyWith(
                                    color: AppColorTheme.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(width: AppSizes.spaceSmall),
                            const Icon(
                              Icons.keyboard_arrow_down_outlined,
                              size: 24.0,
                              color: AppColorTheme.black,
                            ),
                          ],
                        ),
                        Text(
                          '(' +
                              Crypto.numberFormatNumberTokenRate(
                                  _.coinModelTo.amount) +
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

class _CalculatorAmountWidget extends GetView<UpdateAmountSwapController> {
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

class _GroupCompareCurrencyFromWidget
    extends GetView<UpdateAmountSwapController> {
  const _GroupCompareCurrencyFromWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SwapController>(
      id: EnumSwap.RATE,
      builder: (_) {
        return GetBuilder<WalletController>(
          id: EnumUpdateWallet.CURRENCY_ACTIVE,
          builder: (walletController) {
            return Obx(
              () => Text(
                controller.currencyFromCompare,
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

class _GroupCompareCurrencyToWidget
    extends GetView<UpdateAmountSwapController> {
  const _GroupCompareCurrencyToWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SwapController>(
      id: EnumSwap.RATE,
      builder: (_) {
        return GetBuilder<WalletController>(
          id: EnumUpdateWallet.CURRENCY_ACTIVE,
          builder: (walletController) {
            return Obx(
              () => Text(
                controller.currencyToCompare,
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

class _InputAmountInWidget extends StatelessWidget {
  const _InputAmountInWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GetBuilder<UpdateAmountSwapController>(
        id: EnumUpdateInputAmountSwap.BUTTON,
        builder: (_) {
          return TextFormField(
            controller: _.amountInController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.start,
            onTap: () {
              _.isEditAmountOut = false;
              _.isEditAmountIn = true;
            },
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

class _InputAmountOutWidget extends GetView<UpdateAmountSwapController> {
  const _InputAmountOutWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextFormField(
        controller: controller.amountOutController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.start,
        onTap: () {
          controller.isEditAmountOut = true;
          controller.isEditAmountIn = false;
        },
        style: AppTextTheme.number2,
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
      ),
    );
  }
}
