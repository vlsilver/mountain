import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/remove_add_liquidity/remove_add_liquidity_controller.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemoveAddLiquidityApproveConfirmPage
    extends GetView<RemoveAddLiquidityController> {
  const RemoveAddLiquidityApproveConfirmPage({Key? key, this.height})
      : super(key: key);

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
              title: 'global_confirm_approve'.tr,
              isBack: false,
              onTap: () {},
            ),
          ),
          const SizedBox(height: AppSizes.spaceVeryLarge),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.spaceMedium),
              child: Column(
                children: [
                  _ItemInformationAddressWidget(
                    name: controller.addressSender.name,
                    informationAddress:
                        controller.addressSender.addreesFormatWithRoundBrackets,
                    title: 'global_from'.tr,
                  ),
                  const SizedBox(height: AppSizes.spaceSmall),
                  _ItemInformationAddressWidget(
                    name: BlockChainModel.getNameRouterApprove(
                        controller.addLiquidityModel.blockChainId),
                    informationAddress: controller.getNameAddressRouter(),
                    title: 'global_to'.tr,
                  ),
                  const SizedBox(height: AppSizes.spaceVeryLarge),
                  const _GroupInformationAmount(),
                  const SizedBox(height: AppSizes.spaceNormal),
                  Text('information_approve_detail'.tr,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.bodyText2
                          .copyWith(color: AppColorTheme.black40)),
                  const Expanded(child: SizedBox()),
                  GlobalButtonWidget(
                      name: 'global_approve'.tr,
                      type: ButtonType.ACTIVE,
                      onTap: () {
                        controller.handleButtonApproveOnTap();
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

class _GroupInformationAmount extends GetView<RemoveAddLiquidityController> {
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
                          blockChainId: controller.addressSender.blockChainId,
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
                        coinModel: controller.addLiquidityModel.tokenLP,
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
                    coinModel: controller.addLiquidityModel.tokenLP,
                    fee: controller.fee,
                    amount: 0.0,
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

class _ItemInformationAddressWidget extends StatelessWidget {
  const _ItemInformationAddressWidget({
    Key? key,
    required this.title,
    required this.informationAddress,
    required this.name,
  }) : super(key: key);

  final String title;
  final String informationAddress;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(
        width: 48.0,
        child: Text(
          title,
          style: AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black60),
        ),
      ),
      SizedBox(width: AppSizes.spaceMedium),
      Expanded(
        child: Text.rich(
          TextSpan(
              text: name,
              style: AppTextTheme.bodyText1.copyWith(
                  color: AppColorTheme.black, fontWeight: FontWeight.w600),
              children: [
                TextSpan(
                  text: informationAddress,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.black60),
                ),
              ]),
          textAlign: TextAlign.end,
        ),
      )
    ]);
  }
}
