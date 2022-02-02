import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/format_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/address_add_liquidity_list.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/add_liquidity_detail/add_liquidity_detail_controller.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:base_source/app/widget_global/global_avatar_coin_widget.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddLiquidityDetailPage extends GetView<AddLiquidityDetailController> {
  const AddLiquidityDetailPage({
    Key? key,
    this.height,
    required this.data,
  }) : super(key: key);

  final double? height;
  final AddLiquidityModel data;
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
              title: 'add_liquidity_detail'.tr,
              onTap: () {
                Get.back();
              },
            ),
          ),
          const SizedBox(height: AppSizes.spaceMedium),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.spaceMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColorTheme.backGround2,
                        ),
                        child: GlobalAvatarCoinWidget(
                          coinModel: data.tokenA,
                          height: 32.0,
                          width: 32.0,
                        ),
                      ),
                      const SizedBox(width: AppSizes.spaceSmall),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColorTheme.backGround2,
                        ),
                        child: GlobalAvatarCoinWidget(
                          coinModel: data.tokenB,
                          height: 32.0,
                          width: 32.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceSmall),
                  Column(
                    children: [
                      Text(
                        'add_liquidity_your_lp_token'.tr,
                        style: AppTextTheme.bodyText1
                            .copyWith(color: AppColorTheme.black),
                      ),
                      Text(data.tokenLP.valueWithSymbolString,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.body
                              .copyWith(color: AppColorTheme.textAction))
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceVeryLarge),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spaceSmall,
                        vertical: AppSizes.spaceMedium),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppSizes.spaceMedium),
                        border: Border.all(
                            color: AppColorTheme.textAction, width: 0.25)),
                    child: Column(
                      children: [
                        _ItemValueAddressWidget(
                          value: data.blockChainId.capitalizeFirst!,
                          title: 'global_network'.tr,
                        ),
                        const SizedBox(height: AppSizes.spaceSmall),
                        _ItemValueAddressWidget(
                          value: BlockChainModel.getNameRouterApprove(
                              data.blockChainId),
                          title: 'global_contract'.tr,
                        ),
                        const SizedBox(height: AppSizes.spaceSmall),
                        _ItemInformationAddressWidget(
                          address: data.addressRecive,
                          title: 'address_Str'.tr,
                        ),
                        const SizedBox(height: AppSizes.spaceSmall),
                        // _ItemValueAddressWidget(
                        //   value: data.tokenA.valueWithSymbolString,
                        //   title: 'add_liquidity_pooled'
                        //       .trParams({'symbol': data.tokenA.symbol})!,
                        // ),
                        // const SizedBox(height: AppSizes.spaceSmall),
                        // _ItemValueAddressWidget(
                        //   value: data.tokenB.valueWithSymbolString,
                        //   title: 'add_liquidity_pooled'
                        //       .trParams({'symbol': data.tokenB.symbol})!,
                        // ),
                        // const SizedBox(height: AppSizes.spaceSmall),
                        _ItemValueAddressWidget(
                          value: AppFormat.formatShareOfPoolWithValue(
                              data.shareOfPool),
                          title: 'add_liquidity_share_of_pool'
                              .trParams({'symbol': data.tokenB.symbol})!,
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  const _GroupButtonWidget()
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

class _GroupButtonWidget extends GetView<AddLiquidityDetailController> {
  const _GroupButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isRemove = controller.checkRemove();
    return Row(
      children: [
        Expanded(
          child: GlobalButtonWidget(
              name: 'add_liquidity_add_more'.tr,
              type: ButtonType.ACTIVE,
              onTap: () {
                controller.handleAddButtonOnTap();
              }),
        ),
        isRemove ? SizedBox(width: AppSizes.spaceMedium) : SizedBox(),
        isRemove
            ? Expanded(
                child: GlobalButtonWidget(
                    name: 'add_liquidity_remove'.tr,
                    type: ButtonType.ACTIVE,
                    onTap: () {
                      controller.handleButtonRemoveOntap();
                    }),
              )
            : SizedBox(),
      ],
    );
  }
}

class _ItemInformationAddressWidget extends StatelessWidget {
  const _ItemInformationAddressWidget({
    Key? key,
    required this.title,
    required this.address,
  }) : super(key: key);

  final String title;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
        title,
        style: AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black60),
      ),
      SizedBox(width: AppSizes.spaceSmall),
      Expanded(
        child: Text(
          AppFormat.addressStringLarge(address),
          style: AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black),
          textAlign: TextAlign.end,
        ),
      )
    ]);
  }
}

class _ItemValueAddressWidget extends StatelessWidget {
  const _ItemValueAddressWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
        title,
        style: AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black60),
      ),
      SizedBox(width: AppSizes.spaceSmall),
      Expanded(
        child: Text(
          value,
          style: AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black),
          textAlign: TextAlign.end,
        ),
      )
    ]);
  }
}
