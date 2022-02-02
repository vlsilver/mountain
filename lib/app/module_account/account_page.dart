import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/module_account/account_controller.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/widget_global/global_logo_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AccountPage extends GetView<AccountController> {
  const AccountPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 80.0,
          backgroundColor: AppColorTheme.backGround2,
          title: Column(
            children: [
              GlobalLogoWidget(),
              Text(
                'account_str'.tr,
                style: AppTextTheme.title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        backgroundColor: AppColorTheme.backGround2,
        body: GetBuilder<WalletController>(
            id: EnumUpdateWallet.PAGE,
            builder: (_) {
              if (!_.isLoadSuccess) {
                return Center(child: CupertinoActivityIndicator());
              }
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: controller.walletController.blockChains.length + 1,
                  itemBuilder: (context, index) {
                    if (index ==
                        controller.walletController.blockChains.length) {
                      return SizedBox(height: 64.0);
                    }
                    return _ItemsNetworkWidget(
                        blockChainModel:
                            controller.walletController.blockChains[index]);
                  });
            }));
  }
}

class _ItemsNetworkWidget extends GetView<AccountController> {
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
        GetBuilder<AccountController>(
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

class _SlidableAddressItemWidget extends GetView<AccountController> {
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
        controller.handleItemOntap(addressModel);
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
                                .copyWith(color: AppColorTheme.textAction80),
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
