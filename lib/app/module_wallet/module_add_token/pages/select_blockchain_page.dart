import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../add_token_controller.dart';

class SelectBlockChainPage extends GetView<AddTokenController> {
  const SelectBlockChainPage({
    Key? key,
  }) : super(key: key);

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
              title: 'select_network'.tr,
              onTap: controller.handleIcBackLocalOnTap,
            ),
          ),
          SizedBox(height: AppSizes.spaceMedium),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
              child: GetBuilder<AddTokenController>(
                builder: (_) {
                  return ListView.builder(
                      itemCount: _.blockChains.length,
                      itemBuilder: (context, index) {
                        return _BlockChainItemWidget(
                            blockChainModel: _.blockChains[index]);
                      });
                },
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

class _BlockChainItemWidget extends GetView<AddTokenController> {
  const _BlockChainItemWidget({
    required this.blockChainModel,
    Key? key,
  }) : super(key: key);

  final BlockChainModel blockChainModel;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        controller.handleBlockChainItemOnTap(blockChainModel);
      },
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppSizes.spaceVerySmall),
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.spaceSmall, vertical: AppSizes.spaceSmall),
        decoration: BoxDecoration(
            color: AppColorTheme.card60,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                height: 56.0,
                width: 56.0,
                padding: EdgeInsets.all(AppSizes.spaceSmall),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppColorTheme.card),
                child: Image.network(blockChainModel.image)),
            SizedBox(width: AppSizes.spaceMedium),
            Expanded(
              child: Text(blockChainModel.network,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.bodyText1.copyWith(
                      color: AppColorTheme.black, fontWeight: FontWeight.w600)),
            ),
            SizedBox(width: AppSizes.spaceMedium),
          ],
        ),
      ),
    );
  }
}
