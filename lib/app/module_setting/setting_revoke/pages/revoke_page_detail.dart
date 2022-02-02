import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/address_approve_list.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_setting/setting_revoke/revoke_cotroller.dart';
import 'package:base_source/app/module_setting/widget/layout_setting_page.dart';
import 'package:base_source/app/widget_global/global_avatar_coin_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RevokePageDetail extends GetView<RevokeController> {
  const RevokePageDetail({
    Key? key,
    required this.revokeData,
    required this.coinModel,
    required this.onTap,
  }) : super(key: key);

  final RevokeData revokeData;
  final CoinModel coinModel;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutSettingDetailWidget(
      title: 'detail_revoke'.tr,
      body: Column(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSizes.spaceLarge),
                Text(
                  'global_txnHash'.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.bodyText1.copyWith(
                    color: AppColorTheme.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSizes.spaceVerySmall),
                Text(
                  revokeData.hash,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.textAccent80),
                ),
                Divider(color: AppColorTheme.black50, thickness: 1.0),
                SizedBox(height: AppSizes.spaceLarge),
                Text(
                  'global_block'.tr,
                  style: AppTextTheme.bodyText1.copyWith(
                    color: AppColorTheme.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSizes.spaceVerySmall),
                Text(
                  revokeData.block.toString(),
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.textAccent80),
                ),
                Divider(color: AppColorTheme.black50, thickness: 1.0),
                SizedBox(height: AppSizes.spaceLarge),
                Text(
                  'global_contract'.tr,
                  style: AppTextTheme.bodyText1.copyWith(
                    color: AppColorTheme.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSizes.spaceVerySmall),
                Row(
                  children: [
                    coinModel.id.isEmpty
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                                right: AppSizes.spaceVerySmall),
                            child: GlobalAvatarCoinWidget(coinModel: coinModel),
                          ),
                    Flexible(
                      child: Text(
                        revokeData.contracAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextTheme.bodyText1.copyWith(
                          color: AppColorTheme.textAccent80,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(color: AppColorTheme.black50, thickness: 1.0),
                SizedBox(height: AppSizes.spaceLarge),
                Text(
                  'global_sender'.tr,
                  style: AppTextTheme.bodyText1.copyWith(
                    color: AppColorTheme.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSizes.spaceVerySmall),
                Text(
                  revokeData.sender,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.textAccent80),
                ),
                Divider(color: AppColorTheme.black50, thickness: 1.0),
                SizedBox(height: AppSizes.spaceLarge),
                Text(
                  'amount_accepted'.tr,
                  style: AppTextTheme.bodyText1.copyWith(
                    color: AppColorTheme.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSizes.spaceVerySmall),
                Text(
                  Crypto.numberFormatNumberToken(
                          revokeData.valueResidual / coinModel.powDecimals) +
                      ' ' +
                      coinModel.symbol,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.bodyText1.copyWith(
                      color: AppColorTheme.black60,
                      fontWeight: FontWeight.w600),
                ),
                Divider(color: AppColorTheme.black50, thickness: 1.0),
                SizedBox(height: AppSizes.spaceLarge),
                Text(
                  'time_updated'.tr,
                  style: AppTextTheme.bodyText1.copyWith(
                    color: AppColorTheme.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSizes.spaceVerySmall),
                Text(
                  revokeData.timeString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.textAccent80),
                ),
                Divider(color: AppColorTheme.black50, thickness: 1.0),
              ],
            ),
          ),
          Expanded(child: SizedBox(height: AppSizes.spaceMedium)),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSizes.spaceMedium),
            child: GlobalButtonWidget(
                name: 'revoke_link'.tr,
                type: ButtonType.FOCUS,
                onTap: () {
                  onTap();
                }),
          ),
          SizedBox(height: AppSizes.spaceVeryLarge)
        ],
      ),
    );
  }
}
