import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/address_approve_list.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_setting/setting_revoke/revoke_cotroller.dart';
import 'package:base_source/app/module_setting/widget/layout_setting_page.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/widget_global/global_avatar_coin_widget.dart';
import 'package:base_source/app/widget_global/global_empty_list_widget.dart';
import 'package:base_source/app/widget_global/global_error_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RevokePage extends GetView<RevokeController> {
  const RevokePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutSettingDetailWidget(
      title: 'revoke_list'.tr,
      body: Column(
        children: [
          _GroupFollowAddressWidget(),
          SizedBox(height: AppSizes.spaceNormal),
          Expanded(
            child: GetBuilder<RevokeController>(
              id: EnumUpdateRevokePage.TRANSACTION,
              builder: (_) {
                return GetBuilder<WalletController>(
                    id: EnumUpdateWallet.REVOKE_LIST,
                    builder: (walletController) {
                      if (_.state.isLoading) {
                        return Center(
                            child: CupertinoActivityIndicator(radius: 16.0));
                      }
                      if (_.state.isFailure) {
                        return GlobalErrorWidget();
                      }
                      return _.addressActive.revokeDataList!.data.isEmpty
                          ? GlobalEmptyListWidget(
                              title: 'empty_history_revoke'.tr)
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppSizes.spaceMedium),
                              itemCount:
                                  _.addressActive.revokeDataList!.data.length,
                              itemBuilder: (context, index) {
                                if (index ==
                                    _.addressActive.revokeDataList!.data
                                        .length) {
                                  return SizedBox(height: 48.0);
                                }
                                return ItemRevokeWidget(
                                  revokeData: _.addressActive.revokeDataList!
                                      .data[index],
                                );
                              });
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupFollowAddressWidget extends GetView<RevokeController> {
  const _GroupFollowAddressWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RevokeController>(
      id: EnumUpdateRevokePage.ADDRESS_OF_COIN,
      builder: (_) {
        return CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: controller.handleAddressActiveOnTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GetBuilder<WalletController>(
                    id: EnumUpdateWallet.CURRENCY_ACTIVE,
                    builder: (_) {
                      return Text(
                        controller.addressActive.currecyString,
                        style: AppTextTheme.headline2.copyWith(
                            color: AppColorTheme.text,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      );
                    },
                  ),
                  Row(
                    children: [
                      Text(
                        _.addressActive.name,
                        style: AppTextTheme.bodyText1
                            .copyWith(color: AppColorTheme.text),
                      ),
                      SizedBox(width: AppSizes.spaceNormal),
                      Icon(
                        Icons.arrow_drop_down_sharp,
                        color: AppColorTheme.accent,
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class ItemRevokeWidget extends GetView<RevokeController> {
  const ItemRevokeWidget({
    Key? key,
    required this.revokeData,
  }) : super(key: key);
  final RevokeData revokeData;
  @override
  Widget build(BuildContext context) {
    final coinModel = controller.addressActive
        .getCoinModelByAddressContract(revokeData.contracAddress)
        .copyWith(blockchainId: controller.addressActive.blockChainId);

    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSizes.spaceVerySmall),
      height: 72.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: CupertinoButton(
              onPressed: () {
                controller.handleItemRevokeOnTap(revokeData, coinModel);
              },
              padding: EdgeInsets.zero,
              alignment: Alignment.center,
              child: Container(
                height: 72.0,
                padding: EdgeInsets.all(AppSizes.spaceVerySmall),
                decoration: BoxDecoration(
                    color: AppColorTheme.focus,
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(AppSizes.spaceSmall))),
                child: Row(
                  children: [
                    GlobalAvatarCoinWidget(coinModel: coinModel),
                    SizedBox(width: AppSizes.spaceSmall),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                'global_txHash'.tr,
                                style: AppTextTheme.bodyText2
                                    .copyWith(color: AppColorTheme.black60),
                              ),
                              Flexible(
                                  child: Text(
                                revokeData.hash,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextTheme.bodyText2.copyWith(
                                  color: AppColorTheme.textAccent80,
                                ),
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'global_block_revoke'.tr,
                                style: AppTextTheme.bodyText2
                                    .copyWith(color: AppColorTheme.black60),
                              ),
                              Flexible(
                                  child: Text(
                                revokeData.block.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextTheme.bodyText2.copyWith(
                                  color: AppColorTheme.textAccent80,
                                ),
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'global_sender_revoke'.tr,
                                style: AppTextTheme.bodyText2
                                    .copyWith(color: AppColorTheme.black60),
                              ),
                              Flexible(
                                  child: Text(
                                revokeData.sender,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextTheme.bodyText2.copyWith(
                                  color: AppColorTheme.textAccent80,
                                ),
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'global_amount_revoke'.tr,
                                style: AppTextTheme.bodyText2
                                    .copyWith(color: AppColorTheme.black60),
                              ),
                              Flexible(
                                  child: Text(
                                Crypto.numberFormatNumberToken(
                                    revokeData.valueResidual /
                                        coinModel.powDecimals),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextTheme.bodyText2.copyWith(
                                  color: AppColorTheme.textAccent80,
                                ),
                              ))
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: AppSizes.spaceSmall),
                  ],
                ),
              ),
            ),
          ),
          CupertinoButton(
            onPressed: () {
              controller.handleRevokeOnTap(
                coinModel,
                revokeData,
                false,
              );
            },
            padding: EdgeInsets.zero,
            child: Container(
                height: 72.0,
                padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceNormal),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFFF87369), Color(0xFFF98E5C)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(AppSizes.spaceSmall))),
                child: Center(
                  child: Text(
                    'global_revoke'.tr,
                    style: AppTextTheme.bodyText2
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
