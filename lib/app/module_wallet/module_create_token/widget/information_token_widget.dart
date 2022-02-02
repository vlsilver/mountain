import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/module_wallet/module_create_token/create_token_controller.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompleteCreateTokenPage extends GetView<CreateTokenController> {
  const CompleteCreateTokenPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GlobalBottomSheetLayoutWidget(
      height: Get.height * 0.8,
      child: Material(
        color: AppColorTheme.focus,
        child: Column(
          children: [
            const SizedBox(height: AppSizes.spaceSmall),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
              child: AppBarWidget(
                  title: 'global_completed'.tr,
                  onTap: () {
                    Get.back();
                  }),
            ),
            const SizedBox(height: AppSizes.spaceVeryLarge),
            const _GroupInformationAmount(),
            const Expanded(child: SizedBox()),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.spaceMedium),
              child: GlobalButtonWidget(
                  name: 'global_send'.tr,
                  type: ButtonType.ACTIVE,
                  onTap: () {
                    controller.handleButtonOnTap();
                  }),
            ),
            const SizedBox(height: AppSizes.spaceVeryLarge)
          ],
        ),
      ),
    );
  }
}

class _GroupInformationAmount extends GetView<CreateTokenController> {
  const _GroupInformationAmount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceMedium),
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMedium),
      decoration: BoxDecoration(
          color: AppColorTheme.card,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('global_network'.tr,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.black60)),
              const SizedBox(width: AppSizes.spaceNormal),
              Expanded(
                child: Text(
                  controller.blockChainModelActive.network,
                  textAlign: TextAlign.end,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.text),
                ),
              )
            ],
          ),
          const SizedBox(height: AppSizes.spaceSmall),
          Row(
            children: [
              Text('global_creator'.tr,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.black60)),
              const SizedBox(width: AppSizes.spaceNormal),
              Expanded(
                child: Text(
                  controller.addressModelActive.addressFormat,
                  textAlign: TextAlign.end,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.text),
                ),
              )
            ],
          ),
          const SizedBox(height: AppSizes.spaceSmall),
          Row(
            children: [
              Text('name_token'.tr,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.black60)),
              const SizedBox(width: AppSizes.spaceNormal),
              Expanded(
                child: Text(
                  controller.name,
                  textAlign: TextAlign.end,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.text),
                ),
              )
            ],
          ),
          const SizedBox(height: AppSizes.spaceSmall),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('token_symbol'.tr,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.black60)),
              const SizedBox(width: AppSizes.spaceSmall),
              Expanded(
                child: Text(
                  controller.symbol,
                  textAlign: TextAlign.end,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.text),
                ),
              )
            ],
          ),
          const SizedBox(height: AppSizes.spaceSmall),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('hinetotalValueStr'.tr,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.black60)),
              const SizedBox(width: AppSizes.spaceSmall),
              Expanded(
                child: Text(
                  controller.totalController.text + ' ' + controller.symbol,
                  textAlign: TextAlign.end,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.text),
                ),
              )
            ],
          ),
          const SizedBox(height: AppSizes.spaceSmall),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('global_fee_network'.tr,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.black60)),
              const SizedBox(width: AppSizes.spaceSmall),
              Expanded(
                child: Text(
                  controller.feeCurrency(),
                  textAlign: TextAlign.end,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.error),
                ),
              )
            ],
          ),
          const SizedBox(height: AppSizes.spaceSmall),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'global_total'.tr,
                style: AppTextTheme.bodyText1.copyWith(
                    color: AppColorTheme.error, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: AppSizes.spaceNormal),
              Expanded(
                child: Text(
                  TransactionData.totalFormatByData(
                    coinModel: controller.addressModelActive.coinOfBlockChain,
                    fee: controller.fee,
                    amount: 0,
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
