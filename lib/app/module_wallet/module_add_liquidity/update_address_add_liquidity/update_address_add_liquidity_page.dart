import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'update_address_add_liquidity_controller.dart';

class UpdateAddressAddLiquidityPage
    extends GetView<UpdateAddressAddLiquidityController> {
  const UpdateAddressAddLiquidityPage({
    Key? key,
    required this.isFullScreen,
  }) : super(key: key);

  final isFullScreen;

  @override
  Widget build(BuildContext context) {
    controller.isFullScreen = isFullScreen;
    return Scaffold(
      backgroundColor: AppColorTheme.focus,
      resizeToAvoidBottomInset: false,
      appBar: isFullScreen ? _buildAppBar() : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          !isFullScreen ? SizedBox(height: AppSizes.spaceNormal) : SizedBox(),
          !isFullScreen
              ? AppBarWidget(
                  title: 'select_address'.tr,
                  onTap: () {
                    controller.handleIconBackOnTap();
                  })
              : const SizedBox(),
          SizedBox(height: AppSizes.spaceMedium),
          Expanded(
              child: ListView.builder(
            itemCount: controller.blockChainSupport.length,
            itemBuilder: (context, index) {
              final blockChain = controller.blockChainSupport[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: AppColorTheme.accent20,
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.spaceSmall,
                        horizontal: AppSizes.spaceLarge),
                    child: Text(
                      blockChain.network,
                      style: AppTextTheme.bodyText1.copyWith(
                        color: AppColorTheme.containerActive,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: blockChain.addresss
                          .map((address) => _AddressItemWidget(
                                addressModel: address,
                                index: index,
                                blockChain: blockChain,
                              ))
                          .toList())
                ],
              );
            },
          )),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        splashRadius: AppSizes.spaceMedium,
        iconSize: 24.0,
        onPressed: () {
          controller.handleIconBackOnTap();
        },
        icon: Icon(
          Icons.arrow_back_ios_new_outlined,
          size: 24.0,
          color: AppColorTheme.white,
        ),
      ),
      backgroundColor: AppColorTheme.appBarAccent,
      title: Text(
        'select_address'.tr,
        style: AppTextTheme.titleAppbar,
      ),
    );
  }
}

class _AddressItemWidget extends GetView<UpdateAddressAddLiquidityController> {
  const _AddressItemWidget({
    required this.addressModel,
    required this.index,
    required this.blockChain,
    Key? key,
  }) : super(key: key);

  final AddressModel addressModel;
  final BlockChainModel blockChain;
  final int index;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        controller.handleAddressItemOnTap(
          blockChain: blockChain,
          addressModel: addressModel,
        );
      },
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: AppSizes.spaceVerySmall, vertical: AppSizes.spaceSmall),
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.spaceMedium, vertical: AppSizes.spaceSmall),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(addressModel.avatarAddress),
            const SizedBox(width: AppSizes.spaceMedium),
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
          ],
        ),
      ),
    );
  }
}
