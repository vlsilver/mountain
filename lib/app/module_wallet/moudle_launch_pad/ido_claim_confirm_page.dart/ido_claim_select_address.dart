import 'package:base_source/app/core/controller/controller.dart';
import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/models/local_model/ido_model.dart';
import 'package:base_source/app/module_wallet/moudle_launch_pad/ido_claim_confirm_page.dart/ido_claim_confirm_controller.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class IDOClaimSelectAddress extends GetView<IDOClaimController> {
  @override
  Widget build(BuildContext context) {
    return GlobalBottomSheetLayoutWidget(
        height: Get.height * 0.85,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(height: AppSizes.spaceSmall),
          Row(
            children: [
              SizedBox(width: 48.0),
              Expanded(
                child: Text(
                  'select_address'.tr,
                  style: AppTextTheme.headline2
                      .copyWith(color: AppColorTheme.accent),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 48.0)
            ],
          ),
          SizedBox(height: AppSizes.spaceMedium),
          GetBuilder<WalletController>(
            id: EnumUpdateWallet.CURRENCY_ACTIVE,
            builder: (_) {
              return Expanded(
                  child: ListView.builder(
                      itemCount: controller.getDataDeposited.length,
                      itemBuilder: (context, index) {
                        final address =
                            controller.getAddressModelFromAddressDeposited(
                                controller.getDataDeposited[index].address);
                        return _AddressItemWidget(
                          addressModel: address,
                          dataDeposit: controller.getDataDeposited[index],
                        );
                      }));
            },
          )
        ]));
  }
}

class _AddressItemWidget extends GetView<IDOClaimController> {
  const _AddressItemWidget({
    required this.addressModel,
    required this.dataDeposit,
    Key? key,
  }) : super(key: key);

  final AddressModel addressModel;
  final DataDeposit dataDeposit;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        controller.handleAddressItemOnTap(addressModel, dataDeposit);
      },
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: AppSizes.spaceVerySmall,
            vertical: AppSizes.spaceVerySmall),
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.spaceMedium, vertical: AppSizes.spaceSmall),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(addressModel.avatarAddress),
            SizedBox(width: AppSizes.spaceMedium),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(addressModel.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.bodyText2.copyWith(
                              color: AppColorTheme.black,
                              fontWeight: FontWeight.w600)),
                      Flexible(
                        child: Text(addressModel.addreesFormatWithRoundBrackets,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextTheme.bodyText2
                                .copyWith(color: AppColorTheme.black60)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'amount_deposited'.tr + ': ',
                        style: AppTextTheme.bodyText2
                            .copyWith(color: AppColorTheme.black60),
                      ),
                      Text(
                        dataDeposit.formatDeposited +
                            ' ' +
                            controller.idoProjectController.idoModel.symbol,
                        style: AppTextTheme.bodyText2
                            .copyWith(color: AppColorTheme.black60),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'global_claimed'.tr + ': ',
                        style: AppTextTheme.bodyText2
                            .copyWith(color: AppColorTheme.black60),
                      ),
                      Text(
                        dataDeposit.isClaimed
                            ? 'global_claimed'.tr
                            : 'global_not_yet'.tr,
                        style: AppTextTheme.bodyText2
                            .copyWith(color: AppColorTheme.black60),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Text(
                      addressModel.surPlus,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.bodyText2
                          .copyWith(color: AppColorTheme.error),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: AppSizes.spaceNormal),
          ],
        ),
      ),
    );
  }
}
