import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:base_source/app/widget_global/global_avatar_coin_widget.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'ido_deposit_controller.dart';

class IDODepositPage extends GetView<IDODepositController> {
  const IDODepositPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlobalBottomSheetLayoutWidget(
      child: InkWell(
        focusNode: controller.focusNode,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          controller.focusNode.unfocus();
        },
        child: Column(
          children: [
            const SizedBox(height: AppSizes.spaceNormal),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
              child: AppBarWidget(
                  title: 'global_amount'.tr,
                  onTap: () {
                    Get.back();
                  }),
            ),
            SizedBox(height: AppSizes.spaceVeryLarge),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceMedium),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _InputAddressSendWidget(),
                    const SizedBox(height: AppSizes.spaceMedium),
                    const _GroupFromWidget(),
                    const SizedBox(height: AppSizes.spaceMedium),
                    _GroupPricesWidget(),
                    Expanded(child: SizedBox()),
                    GetBuilder<IDODepositController>(
                      id: EnumIDODeposit.BUTTON,
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
                                  name: 'global_deposit'.tr,
                                  type: _.isApproveSuccess && _.isActiveButton
                                      ? ButtonType.ACTIVE
                                      : ButtonType.DISABLE,
                                  onTap: _.handleButtonContinueOnTap),
                            ],
                          );
                        }
                        return GlobalButtonWidget(
                            name: 'global_deposit'.tr,
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
}

class _InputAddressSendWidget extends GetView<IDODepositController> {
  const _InputAddressSendWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 48.0,
          child: Text(
            'global_from'.tr,
            style: AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black),
          ),
        ),
        const SizedBox(width: AppSizes.spaceMedium),
        Expanded(
          child: GestureDetector(
            onTap: () {
              controller.handleInputAddressSendOnTap();
            },
            child: Container(
              padding: EdgeInsets.all(AppSizes.spaceNormal),
              height: 64.0,
              decoration: BoxDecoration(
                  color: AppColorTheme.card,
                  borderRadius:
                      BorderRadius.circular(AppSizes.borderRadiusSmall)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('descSendStr'.tr,
                            style: AppTextTheme.bodyText2
                                .copyWith(color: AppColorTheme.black60)),
                        Flexible(
                            child: GetBuilder<IDODepositController>(
                                id: EnumIDODeposit.ADDRESS_SENDER,
                                builder: (_) {
                                  return GetBuilder<WalletController>(
                                    id: EnumUpdateWallet.CURRENCY_ACTIVE,
                                    builder: (walletController) {
                                      return Row(
                                        children: [
                                          Text(
                                            _.addressModel.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextTheme.bodyText1
                                                .copyWith(
                                                    color: AppColorTheme.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                          Flexible(
                                            child: Text(
                                              _.addressModel
                                                  .currencyStringWithRoundBracks,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextTheme.bodyText1
                                                  .copyWith(
                                                      color:
                                                          AppColorTheme.error,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32.0,
                    width: 32.0,
                    child: SizedBox(
                      height: 32.0,
                      width: 32.0,
                      child: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: AppColorTheme.accent,
                        size: 32.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
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
              const _GoupCoinBaseWidget(),
            ],
          ),
          const SizedBox(height: AppSizes.spaceSmall),
          const _GroupCompareCurrencyFromWidget()
        ],
      ),
    );
  }
}

class _GroupFromCaculatorWidget extends GetView<IDODepositController> {
  const _GroupFromCaculatorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'global_deposit'.tr,
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

class _CalculatorAmountWidget extends GetView<IDODepositController> {
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

class _GroupCompareCurrencyFromWidget extends GetView<IDODepositController> {
  const _GroupCompareCurrencyFromWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      id: EnumUpdateWallet.CURRENCY_ACTIVE,
      builder: (walletController) {
        return Obx(
          () => Text(
            controller.currencyCompare,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black60),
          ),
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
      child: GetBuilder<IDODepositController>(
        id: EnumIDODeposit.BUTTON,
        builder: (_) {
          return TextFormField(
            controller: _.amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.start,
            onTap: () {},
            style: !_.isErrorInput
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

class _GoupCoinBaseWidget extends GetView<IDODepositController> {
  const _GoupCoinBaseWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IDODepositController>(
      id: EnumIDODeposit.COIN,
      builder: (_) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: AppColorTheme.card),
              padding: const EdgeInsets.all(8.0),
              child: GlobalAvatarCoinWidget(
                  height: 24.0, width: 24.0, coinModel: _.coinBase),
            ),
            const SizedBox(width: AppSizes.spaceSmall),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: Get.width / 3),
                      child: Text(
                        _.coinBase.symbol,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextTheme.bodyText1.copyWith(
                            color: AppColorTheme.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                Text(
                  '(' +
                      Crypto.numberFormatNumberTokenRate(_.coinBase.amount) +
                      ')',
                  style: AppTextTheme.bodyText2
                      .copyWith(color: AppColorTheme.black60),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _GroupPricesWidget extends GetView<IDODepositController> {
  const _GroupPricesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('price_and_rate'.tr.toUpperCase(),
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
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              Crypto.numberFormatNumberTokenRate(controller
                                  .idoProjectController
                                  .idoModel
                                  .minBuyBaseDouble),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: AppTextTheme.bodyText2.copyWith(
                                  color: AppColorTheme.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 2.0),
                            Text(
                              'min_buy'.tr,
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
                              Crypto.numberFormatNumberTokenRate(controller
                                  .idoProjectController
                                  .idoModel
                                  .maxBuyBaseDouble),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: AppTextTheme.bodyText2.copyWith(
                                  color: AppColorTheme.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 2.0),
                            Text(
                              'max_buy'.tr,
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
                              Crypto.numberFormatNumberTokenRate(controller
                                  .idoProjectController
                                  .idoModel
                                  .launchpadPrice),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: AppTextTheme.bodyText2.copyWith(
                                  color: AppColorTheme.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 2.0),
                            Text(
                              'add_liquidity_per'.trParams({
                                'symbolFrom': controller.coinBase.symbol,
                                'symbolTo': controller
                                    .idoProjectController.idoModel.symbol,
                              })!,
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
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
