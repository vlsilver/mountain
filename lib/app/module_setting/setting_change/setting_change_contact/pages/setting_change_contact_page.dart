import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/module_setting/widget/layout_setting_page.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../setting_change_contact_controller.dart';

class SettingChangeContactPage extends GetView<SettingChangeContactController> {
  const SettingChangeContactPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutSettingDetailWidget(
      title: 'account'.tr,
      body: _AddresssOfWalletWidget(),
    );
  }
}

class _AddresssOfWalletWidget extends GetView<SettingChangeContactController> {
  const _AddresssOfWalletWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingChangeContactController>(
        id: EnumUpdateSettingContact.NAME,
        builder: (_) {
          return ListView.builder(
              itemCount: controller.blockChains.length,
              itemBuilder: (context, index) {
                final blockChain = controller.blockChains[index];
                if (index == controller.walletController.blockChains.length) {
                  return SizedBox(height: 32.0);
                }
                return _ItemsNetworkWidget(blockChainModel: blockChain);
              });
        });
  }
}

class _ItemsNetworkWidget extends GetView<SettingChangeContactController> {
  const _ItemsNetworkWidget({
    Key? key,
    required this.blockChainModel,
  }) : super(key: key);

  final BlockChainModel blockChainModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: AppColorTheme.accent20,
          padding: EdgeInsets.symmetric(
              horizontal: AppSizes.spaceMedium,
              vertical: AppSizes.spaceVerySmall),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                blockChainModel.network,
                style: AppTextTheme.bodyText1.copyWith(
                    color: AppColorTheme.accent, fontWeight: FontWeight.bold),
              ),
              Expanded(child: SizedBox(width: AppSizes.spaceNormal)),
              CupertinoButton(
                padding: EdgeInsets.only(),
                minSize: 0,
                onPressed: () {
                  controller
                      .handleButtonCreateNewAddressOnTap(blockChainModel.id);
                },
                child: Icon(
                  Icons.add_rounded,
                  size: 24.0,
                  color: AppColorTheme.white,
                ),
              )
            ],
          ),
        ),
        GetBuilder<SettingChangeContactController>(
          id: blockChainModel.id,
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: blockChainModel.addresss.map((address) {
                return _SlidableAddressItemWidget(
                  addressModel: address,
                  isDelete: blockChainModel.addresss.length > 1,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _SlidableAddressItemWidget
    extends GetView<SettingChangeContactController> {
  const _SlidableAddressItemWidget({
    required this.addressModel,
    required this.isDelete,
    Key? key,
  }) : super(key: key);

  final AddressModel addressModel;
  final bool isDelete;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        controller.handleAddressItemOnTap(addressModel);
      },
      child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 72.0 / Get.width,
          secondaryActions: isDelete
              ? [
                  IconSlideAction(
                    color: AppColorTheme.focus,
                    iconWidget: Icon(Icons.delete, color: AppColorTheme.delete),
                    onTap: () {
                      controller.handleDeleteAddressOnTap(addressModel);
                    },
                  ),
                  IconSlideAction(
                    color: AppColorTheme.focus,
                    iconWidget: Icon(Icons.edit, color: AppColorTheme.accent),
                    onTap: () {
                      controller.handleEditAccountOnTap(addressModel);
                    },
                  )
                ]
              : [
                  IconSlideAction(
                    color: AppColorTheme.focus,
                    iconWidget: Icon(Icons.edit, color: AppColorTheme.accent),
                    onTap: () {
                      controller.handleEditAccountOnTap(addressModel);
                    },
                  )
                ],
          actions: isDelete
              ? [
                  IconSlideAction(
                    color: AppColorTheme.focus,
                    iconWidget: Icon(Icons.delete, color: AppColorTheme.delete),
                    onTap: () {
                      controller.handleDeleteAddressOnTap(addressModel);
                    },
                  ),
                  IconSlideAction(
                    color: AppColorTheme.focus,
                    iconWidget: Icon(Icons.edit, color: AppColorTheme.accent),
                    onTap: () {
                      controller.handleEditAccountOnTap(addressModel);
                    },
                  )
                ]
              : [
                  IconSlideAction(
                    color: AppColorTheme.focus,
                    iconWidget: Icon(Icons.edit, color: AppColorTheme.accent),
                    onTap: () {
                      controller.handleEditAccountOnTap(addressModel);
                    },
                  )
                ],
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.spaceMedium,
                vertical: AppSizes.spaceNormal),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SvgPicture.asset(addressModel.avatarAddress),
                SizedBox(width: AppSizes.spaceSmall),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Text(addressModel.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextTheme.bodyText2.copyWith(
                                    color: AppColorTheme.black,
                                    fontWeight: FontWeight.w600)),
                            Flexible(
                              child: Text(
                                  addressModel.addreesFormatWithRoundBrackets,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextTheme.bodyText2
                                      .copyWith(color: AppColorTheme.black60)),
                            ),
                          ],
                        ),
                      ),
                      GetBuilder<WalletController>(
                        id: EnumUpdateWallet.CURRENCY_ACTIVE,
                        builder: (_) {
                          return Text(
                            addressModel.surPlus,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextTheme.bodyText2
                                .copyWith(color: AppColorTheme.highlight),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
