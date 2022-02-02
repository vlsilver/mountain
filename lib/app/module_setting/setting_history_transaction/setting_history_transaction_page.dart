import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/format_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/module_setting/widget/layout_setting_page.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/widget_global/global_empty_list_widget.dart';
import 'package:base_source/app/widget_global/global_error_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'setting_history_transaction_controller.dart';

class SettingHistoryTransactionPage
    extends GetView<SettingHistoryTransactionController> {
  const SettingHistoryTransactionPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutSettingDetailWidget(
      title: 'history_transaction'.tr,
      body: Column(
        children: [
          controller.isOnlyOneAddressModel
              ? _GroupNotiAddressWidget()
              : _GroupFollowAddressWidget(),
          SizedBox(height: AppSizes.spaceNormal),
          Expanded(
            child: GetBuilder<SettingHistoryTransactionController>(
              id: EnumUpdateHistoryTransaction.TRANSACTION,
              builder: (_) {
                return GetBuilder<WalletController>(
                    id: EnumUpdateWallet.CURRENCY_ACTIVE,
                    builder: (walletController) {
                      final transactions = _.transactions();
                      if (_.state.isLoading) {
                        return Center(
                            child: CupertinoActivityIndicator(radius: 16.0));
                      }
                      if (_.state.isFailure) {
                        return GlobalErrorWidget();
                      }
                      return transactions.isEmpty
                          ? GlobalEmptyListWidget(
                              title: 'empty_history_transaction'.tr)
                          : ListView.builder(
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                if (index == transactions.length) {
                                  return SizedBox(height: 48.0);
                                }
                                return ItemTransactionWidget(
                                  transaction: transactions[index],
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

class _GroupNotiAddressWidget
    extends GetView<SettingHistoryTransactionController> {
  const _GroupNotiAddressWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  controller.addressActive.name,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.text),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _GroupFollowAddressWidget
    extends GetView<SettingHistoryTransactionController> {
  const _GroupFollowAddressWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingHistoryTransactionController>(
      id: EnumUpdateHistoryTransaction.ADDRESS_OF_COIN,
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
                      return Container(
                        width: Get.width,
                        child: Text(
                          controller.addressActive.currecyString,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: AppTextTheme.headline2.copyWith(
                              color: AppColorTheme.text,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
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

class ItemTransactionWidget
    extends GetView<SettingHistoryTransactionController> {
  const ItemTransactionWidget({
    Key? key,
    required this.transaction,
  }) : super(key: key);
  final TransactionData transaction;
  @override
  Widget build(BuildContext context) {
    final coinModel =
        transaction.getCoinModel(addressModel: controller.addressActive);
    if (coinModel == null) {
      return SizedBox();
    }
    final isSender =
        transaction.isSender(addressModel: controller.addressActive);
    final address = isSender
        ? 'global_to'.tr + ': ' + AppFormat.addressString(transaction.to)
        : 'global_from'.tr + ': ' + AppFormat.addressString(transaction.from);
    return CupertinoButton(
      onPressed: () {
        controller.handleTransactionItemOnTap(
          transaction: transaction,
          addressModel: controller.addressActive,
          coinModel: coinModel,
        );
      },
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: AppSizes.spaceVerySmall,
          horizontal: AppSizes.spaceMedium,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.spaceSmall,
          vertical: AppSizes.spaceSmall,
        ),
        decoration: BoxDecoration(
            color: AppColorTheme.focus,
            borderRadius: BorderRadius.circular(AppSizes.spaceSmall)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.spaceMedium),
              child: Icon(
                isSender ? Icons.north_east_rounded : Icons.save_alt_rounded,
                color: AppColorTheme.accent,
              ),
            ),
            SizedBox(width: AppSizes.spaceSmall),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.time(),
                  style: AppTextTheme.bodyText2
                      .copyWith(color: AppColorTheme.black60),
                ),
                Text(
                  address,
                  style: AppTextTheme.bodyText2.copyWith(
                    color: AppColorTheme.black60,
                  ),
                ),
                transaction.isPending
                    ? Text(
                        'global_pending'.tr,
                        style: AppTextTheme.bodyText2.copyWith(
                          color: AppColorTheme.highlight,
                        ),
                      )
                    : transaction.isFailure
                        ? Text(
                            'global_canceled'.tr,
                            style: AppTextTheme.bodyText2.copyWith(
                              color: AppColorTheme.error,
                            ),
                          )
                        : Text(
                            'global_confirmed'.tr,
                            style: AppTextTheme.bodyText2.copyWith(
                              color: AppColorTheme.toggleableActiveColor,
                            ),
                          ),
              ],
            ),
            SizedBox(width: AppSizes.spaceSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          transaction.valueFormatString(coinModel),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          style: AppTextTheme.bodyText1.copyWith(
                              color: AppColorTheme.text,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        ' ' + coinModel.symbol,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppTextTheme.bodyText1.copyWith(
                            color: AppColorTheme.text,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Text(
                    transaction.valueFormatCurrencyByCoinModel(coinModel),
                    style: AppTextTheme.bodyText2
                        .copyWith(color: AppColorTheme.text60),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
