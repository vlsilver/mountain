import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../add_token_controller.dart';

class AddTokenReviewPage extends GetView<AddTokenController> {
  const AddTokenReviewPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceLarge),
        child: Material(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
          color: AppColorTheme.focus,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppSizes.spaceSmall,
                    right: AppSizes.spaceSmall,
                  ),
                  child: SizedBox(
                    height: 32.0,
                    width: 32.0,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      iconSize: 32.0,
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.close),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
                child: Column(
                  children: [
                    Text(
                      'global_result_search'.tr,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.headline2.copyWith(
                          color: AppColorTheme.error,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: AppSizes.spaceLarge),
                    _CoinItemWidget(),
                    SizedBox(height: AppSizes.spaceLarge),
                    GlobalButtonWidget(
                        name: 'global_add_to_menu'.tr,
                        type: ButtonType.ACTIVE,
                        onTap: controller.handleButtonAddToMenu),
                    SizedBox(height: AppSizes.spaceLarge),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoinItemWidget extends GetView<AddTokenController> {
  const _CoinItemWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            padding: EdgeInsets.all(AppSizes.spaceNormal),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: AppColorTheme.card),
            child: controller.coinModelResult.image.isNotEmpty
                ? Image.network(
                    controller.coinModelResult.image,
                    height: 32,
                    width: 32,
                  )
                : Center(
                    child: Text(
                      controller.coinModelResult.symbol,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.bodyText2
                          .copyWith(color: AppColorTheme.accent),
                    ),
                  ),
          ),
          SizedBox(width: AppSizes.spaceMedium),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(controller.coinModelResult.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.bodyText1.copyWith(
                      color: AppColorTheme.black, fontWeight: FontWeight.w600)),
              Text(controller.coinModelResult.type,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.bodyText2
                      .copyWith(color: AppColorTheme.black60)),
            ],
          ),
        ],
      ),
    );
  }
}
