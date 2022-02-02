import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/module_wallet/moudle_launch_pad/ido_deposit.dart/ido_deposit_controller.dart';
import 'package:base_source/app/module_wallet/moudle_launch_pad/ido_project/ido_project_controller.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:base_source/app/module_wallet/module_swap/swap_controller.dart';
import 'package:base_source/app/widget_global/global_avatar_coin_widget.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IDODepositConfirmPage extends GetView<IDODepositController> {
  const IDODepositConfirmPage({Key? key, this.height}) : super(key: key);

  final double? height;
  @override
  Widget build(BuildContext context) {
    return GlobalBottomSheetLayoutWidget(
      height: height ?? Get.height * 0.85,
      child: Column(
        children: [
          const SizedBox(height: AppSizes.spaceNormal),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
            child: AppBarWidget(
              title: 'global_deposit_confirm'.tr,
              onTap: () {
                Get.back();
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.spaceMedium),
              child: Column(
                children: [
                  const SizedBox(height: AppSizes.spaceLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColorTheme.backGround),
                        child: GlobalAvatarCoinWidget(
                            coinModel: controller.coinBase),
                      ),
                      const SizedBox(width: AppSizes.spaceSmall),
                      const Icon(Icons.east_outlined,
                          color: AppColorTheme.black),
                      const SizedBox(width: AppSizes.spaceSmall),
                      Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColorTheme.backGround),
                        child: GlobalAvatarCoinWidget(
                          coinModel: CoinModel.empty().copyWith(
                              image:
                                  controller.idoProjectController.idoModel.icon,
                              symbol: controller
                                  .idoProjectController.idoModel.symbol),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceLarge),
                  const _GroupInformationAmount(),
                  const Expanded(child: SizedBox()),
                  GlobalButtonWidget(
                      name: 'global_deposit'.tr,
                      type: ButtonType.ACTIVE,
                      onTap: () {
                        controller.handleButtonDepositOnTap();
                      })
                ],
              ),
            ),
          ),
          const SizedBox(
            height: AppSizes.spaceVeryLarge,
          )
        ],
      ),
    );
  }
}

class _GroupInformationAmount extends GetView<IDODepositController> {
  const _GroupInformationAmount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.spaceLarge),
      decoration: BoxDecoration(
          color: AppColorTheme.card,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('address_Str'.tr,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.black60)),
              const SizedBox(width: AppSizes.spaceNormal),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        controller.addressModel.addressFormat,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: AppTextTheme.bodyText1
                            .copyWith(color: AppColorTheme.black80),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: AppSizes.spaceNormal),
          Row(
            children: [
              Text('global_amount_deposit'.tr,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.black60)),
              const SizedBox(width: AppSizes.spaceNormal),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        controller.coinBase.valueWithSymbol(controller.amount),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: AppTextTheme.bodyText1
                            .copyWith(color: AppColorTheme.black80),
                      ),
                    ),
                    Text(' - ',
                        style: AppTextTheme.bodyText1
                            .copyWith(color: AppColorTheme.text)),
                    Text(
                      controller.coinBase.currencyOfValue(controller.amount),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: AppTextTheme.bodyText1
                          .copyWith(color: AppColorTheme.black80),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: AppSizes.spaceNormal),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('global_fee_network'.tr,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.black60)),
              const SizedBox(width: AppSizes.spaceSmall),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        TransactionData.feeFormatWithSymbolByData(
                          fees: controller.fee,
                          blockChainId: controller.addressModel.blockChainId,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: AppTextTheme.bodyText1
                            .copyWith(color: AppColorTheme.black80),
                      ),
                    ),
                    Text(' - ',
                        style: AppTextTheme.bodyText1
                            .copyWith(color: AppColorTheme.text)),
                    Text(
                      TransactionData.totalFormatByData(
                        coinModel: controller.coinBase,
                        fee: controller.fee,
                        amount: 0.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: AppTextTheme.bodyText1
                          .copyWith(color: AppColorTheme.black80),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: AppSizes.spaceNormal),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'global_total'.tr,
                style: AppTextTheme.bodyText1.copyWith(
                    color: AppColorTheme.error, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: AppSizes.spaceNormal),
              Expanded(
                child: Text(
                  TransactionData.totalFormatByData(
                    coinModel: controller.coinBase,
                    fee: controller.fee,
                    amount: controller.amount,
                  ),
                  textAlign: TextAlign.end,
                  style: AppTextTheme.bodyText1.copyWith(
                      color: AppColorTheme.error, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
