import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/widget_global/global_avatar_coin_widget.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_input_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'select_coin_pair_controller.dart';

class SelectCoinPairPage extends GetView<SelectCoinPairController> {
  const SelectCoinPairPage({
    Key? key,
    required this.addressModel,
    required this.coinFrom,
    required this.coinTo,
    required this.height,
  }) : super(key: key);

  final AddressModel addressModel;
  final CoinModel coinFrom;
  final CoinModel coinTo;
  final double height;

  @override
  Widget build(BuildContext context) {
    controller.handleInitDataController(
      addressModel: addressModel,
      coinFromInit: coinFrom,
      coinToInit: coinTo,
    );
    return GlobalBottomSheetLayoutWidget(
      height: height,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusNode: controller.focusNode,
        onTap: () {
          controller.focusNode.unfocus();
        },
        child: DefaultTabController(
          length: 2,
          initialIndex: controller.isFrom ? 0 : 1,
          child: Builder(builder: (context) {
            controller.tabController = DefaultTabController.of(context)!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSizes.spaceSmall),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceLarge),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0.0,
                        bottom: 0.0,
                        child: SizedBox(
                            height: 24.0,
                            width: 24.0,
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              splashRadius: 24.0,
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(Icons.arrow_back_ios),
                              color: AppColorTheme.accent,
                            )),
                      ),
                      Center(
                        child: Text(
                          controller.titleSelectCoinStr,
                          style: AppTextTheme.headline2
                              .copyWith(color: AppColorTheme.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Positioned(
                        right: 0.0,
                        bottom: 0.0,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 0,
                          onPressed: () {
                            controller.handleDoneOnTap();
                          },
                          child: Text(
                            'global_done'.tr,
                            style: AppTextTheme.bodyText1.copyWith(
                                color: AppColorTheme.textAction,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const _TabarWidget(),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: AppSizes.spaceMedium),
                  child: GlobalInputSearchWidget(
                      hintText: controller.hintStr,
                      onChange: (value) {
                        controller.searchText.value = value;
                      },
                      textInputType: TextInputType.text,
                      color: AppColorTheme.focus),
                ),
                Container(
                  height: AppSizes.spaceMedium,
                  decoration: BoxDecoration(
                    color: AppColorTheme.white,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0.0, 4.0),
                          blurRadius: 4.0,
                          color: AppColorTheme.black25),
                    ],
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TabBarView(
                    children: [
                      _CoinsOfWalletWidget(),
                      _CoinsOfWalletWidget(),
                    ],
                  ),
                )),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _TabarWidget extends StatelessWidget {
  const _TabarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceLarge, vertical: AppSizes.spaceMedium),
        child: TabBar(
            indicatorWeight: 4.0,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: AppColorTheme.textAction,
            labelColor: AppColorTheme.textAction,
            labelStyle: AppTextTheme.bodyText1.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelColor: AppColorTheme.black60,
            isScrollable: true,
            onTap: (index) {},
            tabs: [
              Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
                child: Text('global_from'.tr.toUpperCase()),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
                child: Text('global_to'.tr.toUpperCase()),
              ),
            ]));
  }
}

class _CoinsOfWalletWidget extends GetView<SelectCoinPairController> {
  const _CoinsOfWalletWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectCoinPairController>(
      id: EnumSelectCoinPairOfAddress.SEARCH,
      builder: (_) {
        if (_.coinsSearch.isEmpty) {
          return Center(
            child: Text('global_not_found'.tr,
                style: AppTextTheme.headline2.copyWith(
                  color: AppColorTheme.accent,
                )),
          );
        }
        return Scrollbar(
          child: ListView.builder(
              itemCount: _.coinsSearch.length,
              itemBuilder: (context, index) {
                final coin = _.coinsSearch[index];
                final isSelect = _.isCoinSelect(coin);
                return _CoinItemWidget(
                  coinModel: coin,
                  isSelect: isSelect,
                  // idBack: idBack,
                );
              }),
        );
      },
    );
  }
}

class _CoinItemWidget extends GetView<SelectCoinPairController> {
  const _CoinItemWidget({
    required this.coinModel,
    required this.isSelect,
    Key? key,
  }) : super(key: key);

  final CoinModel coinModel;
  final bool isSelect;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        controller.handleCoinItemOnTap(coinModel);
      },
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppSizes.spaceVerySmall),
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.spaceSmall, vertical: AppSizes.spaceSmall),
        decoration: BoxDecoration(
            color: isSelect
                ? AppColorTheme.toggleableActiveColor.withOpacity(0.2)
                : AppColorTheme.focus,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 56.0,
              width: 56.0,
              padding: EdgeInsets.all(AppSizes.spaceNormal),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: AppColorTheme.card),
              child: GlobalAvatarCoinWidget(coinModel: coinModel),
            ),
            SizedBox(width: AppSizes.spaceMedium),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Get.width / 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(coinModel.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.bodyText1.copyWith(
                          color: AppColorTheme.black,
                          fontWeight: FontWeight.w600)),
                  Text(coinModel.type,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.bodyText2
                          .copyWith(color: AppColorTheme.black60)),
                ],
              ),
            ),
            SizedBox(width: AppSizes.spaceMedium),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                        Crypto.numberFormatNumberToken(coinModel.amount),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: AppTextTheme.bodyText1.copyWith(
                            color: AppColorTheme.text,
                            fontWeight: FontWeight.w600)),
                  ),
                  Text(' ' + coinModel.symbol,
                      textAlign: TextAlign.right,
                      style: AppTextTheme.bodyText1.copyWith(
                          color: AppColorTheme.text,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
