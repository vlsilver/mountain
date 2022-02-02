import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/format_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/address_approve_list.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/module_setting/setting_revoke/revoke_cotroller.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RevokeSendTransactionPage extends GetView<RevokeController> {
  const RevokeSendTransactionPage({
    Key? key,
    required this.revokeData,
    required this.isDetail,
  }) : super(key: key);

  final RevokeData revokeData;
  final bool isDetail;

  @override
  Widget build(BuildContext context) {
    return GlobalBottomSheetLayoutWidget(
      child: Column(
        children: [
          SizedBox(height: AppSizes.spaceNormal),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
            child: AppBarWidget(
                title: 'send_confirm'.tr,
                onTap: () {
                  Get.back();
                }),
          ),
          SizedBox(height: AppSizes.spaceVeryLarge),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.spaceMedium),
              child: Column(
                children: [
                  _ItemInformationAddressWidget(
                    name: controller.addressActive.name,
                    informationAddress:
                        controller.addressActive.addreesFormatWithRoundBrackets,
                    title: 'global_owner'.tr,
                  ),
                  SizedBox(height: AppSizes.spaceSmall),
                  _ItemInformationAddressWidget(
                    name: '',
                    informationAddress:
                        AppFormat.addressString(revokeData.sender),
                    title: 'global_sender'.tr,
                  ),
                  SizedBox(height: AppSizes.spaceVeryLarge),
                  _GroupInformationAmount(),
                  Expanded(child: SizedBox()),
                  GlobalButtonWidget(
                      name: 'global_send'.tr,
                      type: ButtonType.ACTIVE,
                      onTap: () {
                        controller.handleCreateRevokeTransaction(
                          revokeData: revokeData,
                          isDetail: isDetail,
                        );
                      })
                ],
              ),
            ),
          ),
          SizedBox(
            height: AppSizes.spaceVeryLarge,
          )
        ],
      ),
    );
  }
}

class _GroupInformationAmount extends GetView<RevokeController> {
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
              Text('global_amount'.tr,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.black60)),
              Expanded(child: SizedBox(width: AppSizes.spaceNormal)),
              Text(
                '0.0',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: AppTextTheme.bodyText1
                    .copyWith(color: AppColorTheme.black80),
              )
            ],
          ),
          SizedBox(height: AppSizes.spaceNormal),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('global_fee_network'.tr,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.black60)),
              SizedBox(width: AppSizes.spaceSmall),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        TransactionData.feeFormatWithSymbolByData(
                          fees: controller.fee,
                          blockChainId: controller.addressActive.blockChainId,
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
                        coinModel: controller.addressActive.coinOfBlockChain,
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
          SizedBox(height: AppSizes.spaceNormal),
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
                    coinModel: controller.addressActive.coinOfBlockChain,
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
