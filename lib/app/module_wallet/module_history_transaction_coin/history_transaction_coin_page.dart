import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/format_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/module_wallet/widget/feature_item_widget.dart';
import 'package:base_source/app/widget_global/global_avatar_coin_widget.dart';
import 'package:base_source/app/widget_global/global_empty_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'history_transaction_coin_controller.dart';

class HistoryTransactionCoinPage
    extends GetView<HistoryTransactionCoinController> {
  const HistoryTransactionCoinPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          color: AppColorTheme.containerChild,
          image: DecorationImage(
            image: AssetImage('assets/wallet/bg_coin_history.png'),
            fit: BoxFit.cover,
          )),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.0,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(height: AppSizes.spaceNormal),
            _AppbarWidget(),
            Expanded(
              child: NestedScrollView(
                  controller: controller.scrollController,
                  physics: BouncingScrollPhysics(),
                  headerSliverBuilder: (context, isBoxScroll) {
                    return [_GroupValueWidget()];
                  },
                  body: _ListDetailCoinWidget()),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupValueWidget extends StatelessWidget {
  const _GroupValueWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryTransactionCoinController>(
      id: EnumUpdateHistoryTransactionCoin.TRANSACTION,
      builder: (_) {
        return GetBuilder<WalletController>(
          id: EnumUpdateWallet.CURRENCY_ACTIVE,
          builder: (walletController) {
            return SliverAppBar(
              expandedHeight: _.isStellarChain
                  ? Get.width / 2 * 0.55 + 112.0
                  : Get.width / 2 * 0.55 + 68.0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.only(
                      left: AppSizes.spaceLarge, right: AppSizes.spaceLarge),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            _.coinModelSelect.valueNoRoundBrackets,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextTheme.bodyText1.copyWith(
                                fontSize: 20.0,
                                color: AppColorTheme.text80,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            _.coinModelSelect.currencyString,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextTheme.bodyText1
                                .copyWith(color: AppColorTheme.text60),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppSizes.spaceMedium),
                          _.isStellarChain
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppSizes.spaceMedium),
                                  child: Text(
                                    'history_pi'.trParams({
                                      'network': _.network,
                                      'symbol': _.coinModelSelect.symbol
                                    })!,
                                    textAlign: TextAlign.center,
                                    style: AppTextTheme.bodyText1.copyWith(
                                        color: AppColorTheme.textAccent80),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                      const _FeaturesItemWidget(),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AppbarWidget extends StatelessWidget {
  const _AppbarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryTransactionCoinController>(
        id: EnumUpdateHistoryTransactionCoin.APPBAR,
        builder: (_) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
            child: Row(
              children: [
                SizedBox(
                  width: 24.0,
                  child: IconButton(
                    iconSize: 24.0,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 24.0,
                      color: AppColorTheme.focus,
                    ),
                  ),
                ),
                Visibility(
                  visible: _.visibleAppBar,
                  child: Flexible(
                    child: Row(
                      children: [
                        SizedBox(width: AppSizes.spaceNormal),
                        Container(
                          height: 32.0,
                          width: 32.0,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColorTheme.focus),
                          child: GlobalAvatarCoinWidget(
                            coinModel: _.coinModelSelect,
                            height: 28.0,
                            width: 28.0,
                          ),
                        ),
                        SizedBox(width: AppSizes.spaceSmall),
                        GetBuilder<HistoryTransactionCoinController>(
                          id: EnumUpdateHistoryTransactionCoin.TRANSACTION,
                          builder: (_) {
                            return GetBuilder<WalletController>(
                              id: EnumUpdateWallet.CURRENCY_ACTIVE,
                              builder: (walletController) {
                                return Flexible(
                                  child: Text(
                                    _.coinModelSelect.valueNoRoundBrackets,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextTheme.bodyText1.copyWith(
                                      color: AppColorTheme.text80,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !_.visibleAppBar,
                  child: Expanded(
                    child: Column(
                      children: [
                        CupertinoButton(
                          onPressed: () {
                            _.handleAvatarCoinOnTap(_.coinModelSelect);
                          },
                          padding: EdgeInsets.zero,
                          child: CircleAvatar(
                            radius: 24.0,
                            backgroundColor: AppColorTheme.focus,
                            child: GlobalAvatarCoinWidget(
                              coinModel: _.coinModelSelect,
                              height: 40.0,
                              width: 40.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 24.0)
              ],
            ),
          );
        });
  }
}

class _FeaturesItemWidget extends GetView<HistoryTransactionCoinController> {
  const _FeaturesItemWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spacePadding = (Get.width - 36 - 3 * (Get.width / 2) * .55) / 3;
    var featureNames = controller.supportSwap
        ? [
            'receive_str'.tr,
            'feature_copy'.tr,
            'global_send'.tr,
            'global_swap'.tr,
          ]
        : [
            'receive_str'.tr,
            'feature_copy'.tr,
            'global_send'.tr,
          ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: List.generate(featureNames.length, (index) => index)
              .map((index) => CupertinoButton(
                  onPressed: () {
                    controller.handleItemFeatureOnTap(index: index);
                  },
                  padding: EdgeInsets.only(right: spacePadding),
                  child: FeatureItemWidget(
                    color: controller.colorIconList[index],
                    name: featureNames[index],
                    icon: index == 3 ? null : controller.icons[index],
                    svg: index == 3 ? controller.icons[index] : '',
                  )))
              .toList()),
    );
  }
}

class _ListDetailCoinWidget extends GetView<HistoryTransactionCoinController> {
  const _ListDetailCoinWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.only(top: AppSizes.spaceSmall),
      decoration: BoxDecoration(
          color: AppColorTheme.container,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.borderRadiusVeryLarge))),
      child: Column(
        children: [
          CupertinoButton(
            onPressed: controller.handleAddressActiveOnTap,
            padding: const EdgeInsets.only(
              left: AppSizes.spaceMedium,
              right: AppSizes.spaceMedium,
              top: AppSizes.spaceSmall,
            ),
            child: Row(
              children: [
                Text(
                  'history_transaction_of'.tr,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.black60),
                ),
                Flexible(
                  child: GetBuilder<HistoryTransactionCoinController>(
                    id: EnumUpdateHistoryTransactionCoin.TRANSACTION,
                    builder: (_) {
                      return Text(
                        _.addressSelect.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextTheme.bodyText1.copyWith(
                            color: AppColorTheme.black,
                            fontWeight: FontWeight.w600),
                      );
                    },
                  ),
                ),
                SizedBox(width: AppSizes.spaceNormal),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColorTheme.black,
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: AppColorTheme.backGround70,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppSizes.borderRadiusVeryLarge))),
                child: GetBuilder<HistoryTransactionCoinController>(
                  id: EnumUpdateHistoryTransactionCoin.TRANSACTION,
                  builder: (_) {
                    return GetBuilder<WalletController>(
                        id: EnumUpdateWallet.CURRENCY_ACTIVE,
                        builder: (walletController) {
                          final transactions = _.transactions();
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
                                      addressModel: _.addressSelect,
                                      coinModel: _.coinModelSelect,
                                    );
                                  });
                        });
                  },
                )),
          ),
        ],
      ),
    );
  }
}

class ItemTransactionWidget extends GetView<HistoryTransactionCoinController> {
  const ItemTransactionWidget({
    Key? key,
    required this.addressModel,
    required this.coinModel,
    required this.transaction,
  }) : super(key: key);
  final TransactionData transaction;
  final AddressModel addressModel;
  final CoinModel coinModel;

  @override
  Widget build(BuildContext context) {
    if (coinModel.contractAddress != transaction.contractAddress) {
      return SizedBox();
    }
    final isSender = transaction.isSender(addressModel: addressModel);
    final address = isSender
        ? 'global_to'.tr + ': ' + AppFormat.addressString(transaction.to)
        : 'global_from'.tr + ': ' + AppFormat.addressString(transaction.from);

    return CupertinoButton(
      onPressed: () {
        controller.handleTransactionItemOnTap(
          transaction: transaction,
          addressModel: addressModel,
          coinModel: coinModel,
        );
      },
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppSizes.spaceMedium,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.spaceSmall,
          vertical: AppSizes.spaceNormal,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.spaceMedium),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: AppColorTheme.card60),
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
                    style: AppTextTheme.bodyText1
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
