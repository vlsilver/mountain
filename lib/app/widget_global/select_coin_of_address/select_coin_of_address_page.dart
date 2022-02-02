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

import 'select_coin_of_address_controller.dart';

class SelectCoinOfAddressPage extends GetView<SelectCoinOfAddressController> {
  const SelectCoinOfAddressPage({
    Key? key,
    required this.addressModel,
    required this.height,
  }) : super(key: key);

  final AddressModel addressModel;
  final double height;

  @override
  Widget build(BuildContext context) {
    controller.handleInitDataController(addressModel);
    return GlobalBottomSheetLayoutWidget(
      height: height,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusNode: controller.focusNode,
        onTap: () {
          controller.focusNode.unfocus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(height: AppSizes.spaceSmall),
                  Row(
                    children: [
                      SizedBox(
                        height: 48.0,
                        width: 48.0,
                        child: IconButton(
                            onPressed: () {
                              controller.handleIconBackOnTap();
                            },
                            icon: Icon(Icons.arrow_back_ios_new_rounded)),
                      ),
                      Expanded(
                        child: Text(
                          controller.titleSelectCoinStr,
                          style: AppTextTheme.headline2
                              .copyWith(color: AppColorTheme.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 48.0, width: 48.0),
                    ],
                  ),
                  SizedBox(height: AppSizes.spaceSmall),
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
                ],
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _CoinsOfWalletWidget(),
            )),
          ],
        ),
      ),
    );
  }
}

class _CoinsOfWalletWidget extends GetView<SelectCoinOfAddressController> {
  const _CoinsOfWalletWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectCoinOfAddressController>(
      id: EnumSelectCoinOfAddress.SEARCH,
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
                return _CoinItemWidget(
                  coinModel: coin,
                );
              }),
        );
      },
    );
  }
}

class _CoinItemWidget extends GetView<SelectCoinOfAddressController> {
  const _CoinItemWidget({
    required this.coinModel,
    Key? key,
  }) : super(key: key);

  final CoinModel coinModel;

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
            color: AppColorTheme.focus,
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
