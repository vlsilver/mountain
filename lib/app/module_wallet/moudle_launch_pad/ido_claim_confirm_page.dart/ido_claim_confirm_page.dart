import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/module_wallet/moudle_launch_pad/ido_claim_confirm_page.dart/ido_claim_confirm_controller.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IDOClaimConfirmPage extends GetView<IDOClaimController> {
  const IDOClaimConfirmPage({Key? key, required this.addressModel})
      : super(key: key);

  final AddressModel addressModel;
  @override
  Widget build(BuildContext context) {
    return GlobalBottomSheetLayoutWidget(
      height: Get.height * 0.8,
      child: Column(
        children: [
          const SizedBox(height: AppSizes.spaceNormal),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
            child: AppBarWidget(
              title: 'global_claim_confirm'.tr,
              onTap: () {
                Get.back();
              },
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
                    name: addressModel.name,
                    informationAddress:
                        addressModel.addreesFormatWithRoundBrackets,
                    title: 'global_from'.tr,
                  ),
                  const SizedBox(height: AppSizes.spaceVeryLarge),
                  _GroupInformationAmount(addressModel: addressModel),
                  const SizedBox(height: AppSizes.spaceNormal),
                  Text('information_approve_detail'.tr,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.bodyText2
                          .copyWith(color: AppColorTheme.black40)),
                  const Expanded(child: SizedBox()),
                  GlobalButtonWidget(
                      name: 'global_claim'.tr,
                      type: ButtonType.ACTIVE,
                      onTap: () {
                        // controller.handleButtonApproveOnTap();
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

class _GroupInformationAmount extends GetView<IDOClaimController> {
  const _GroupInformationAmount({
    Key? key,
    required this.addressModel,
  }) : super(key: key);

  final AddressModel addressModel;

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
                          blockChainId: addressModel.blockChainId,
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
                        coinModel: addressModel.coinOfBlockChain,
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
                    coinModel: addressModel.coinOfBlockChain,
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
