import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/asset_values.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/module_wallet/widget/input_widget.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'update_address_controller.dart';

class UpdateAddressPage1 extends GetView<UpdateAddressController1> {
  const UpdateAddressPage1({
    Key? key,
    required this.isFullScreen,
    required this.addressRecieve,
    required this.addressSend,
  }) : super(key: key);

  final bool isFullScreen;
  final AddressModel addressSend;
  final AddressModel addressRecieve;

  @override
  Widget build(BuildContext context) {
    controller.handleInitData(
        addressSendInit: addressSend,
        addressRecieveInit: addressSend,
        isFullScreenInit: isFullScreen);
    return Scaffold(
      backgroundColor: AppColorTheme.focus,
      resizeToAvoidBottomInset: false,
      appBar: isFullScreen ? _buildAppBar() : null,
      body: InkWell(
        focusNode: controller.focusNode,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          controller.handleScreenOnTap();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              !isFullScreen
                  ? const SizedBox(height: AppSizes.spaceNormal)
                  : const SizedBox(),
              !isFullScreen
                  ? Text(
                      'select_address'.tr,
                      style: AppTextTheme.headline2
                          .copyWith(color: AppColorTheme.black),
                      textAlign: TextAlign.center,
                    )
                  : const SizedBox(),
              const SizedBox(height: AppSizes.spaceMedium),
              const _InputAddressSendWidget(),
              const SizedBox(height: AppSizes.spaceMedium),
              const _InputAddressReceiveWidget(),
              const SizedBox(height: AppSizes.spaceLarge),
              const _GroupSelectFastAddressWidget(),
              const Expanded(child: SizedBox()),
              GetBuilder<UpdateAddressController1>(
                id: EnumUpdateAddress.GROUP_ERROR,
                builder: (_) {
                  if (_.valid) {
                    return const SizedBox();
                  } else {
                    return const _GroupShowErrorWidget();
                  }
                },
              ),
              GetBuilder<UpdateAddressController1>(
                id: EnumUpdateAddress.BUTTON_CONTINUE,
                builder: (_) {
                  return GlobalButtonWidget(
                      name: 'global_btn_continue'.tr,
                      type: _.isActiveButtonContinue
                          ? ButtonType.ACTIVE
                          : ButtonType.DISABLE,
                      onTap: () {
                        controller.handleButtonContinueOnTap();
                      });
                },
              ),
              const SizedBox(height: AppSizes.spaceVeryLarge),
            ],
          ),
        ),
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
          Get.back();
        },
        icon: const Icon(
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

class _InputAddressSendWidget extends GetView<UpdateAddressController1> {
  const _InputAddressSendWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 48.0,
          child: Text(
            'global_from'.tr,
            style: AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black),
          ),
        ),
        const SizedBox(width: AppSizes.spaceMedium),
        Expanded(
          child: GestureDetector(
            onTap: () {
              controller.handleInputAddressSendOnTap();
            },
            child: Container(
              padding: EdgeInsets.all(AppSizes.spaceNormal),
              height: 64.0,
              decoration: BoxDecoration(
                  color: AppColorTheme.card,
                  borderRadius:
                      BorderRadius.circular(AppSizes.borderRadiusSmall)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('descSendStr'.tr,
                            style: AppTextTheme.bodyText2
                                .copyWith(color: AppColorTheme.black60)),
                        Flexible(
                            child: GetBuilder<UpdateAddressController1>(
                                id: EnumUpdateAddress.ADDRESS_SENDER,
                                builder: (_) {
                                  return GetBuilder<WalletController>(
                                    id: EnumUpdateWallet.CURRENCY_ACTIVE,
                                    builder: (walletController) {
                                      return Row(
                                        children: [
                                          Text(
                                            _.addressSend.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextTheme.bodyText1
                                                .copyWith(
                                                    color: AppColorTheme.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                          Flexible(
                                            child: Text(
                                              _.addressSend
                                                  .currencyStringWithRoundBracks,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextTheme.bodyText1
                                                  .copyWith(
                                                      color:
                                                          AppColorTheme.error,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32.0,
                    width: 32.0,
                    child: SizedBox(
                      height: 32.0,
                      width: 32.0,
                      child: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: AppColorTheme.accent,
                        size: 32.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _InputAddressReceiveWidget extends GetView<UpdateAddressController1> {
  const _InputAddressReceiveWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 48.0,
          child: Text(
            'global_to'.tr,
            style: AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black),
          ),
        ),
        const SizedBox(width: AppSizes.spaceMedium),
        Expanded(
          child: Stack(
            children: [
              InputWidget(
                  textStyle: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.black),
                  controller: controller.receiveController,
                  right: 68,
                  onTap: controller.handleInputReceiveAddressOnTap,
                  hintText: 'hintReceiveStr'.tr),
              Positioned(
                right: 32.0,
                top: 0.0,
                bottom: 0.0,
                child: IconButton(
                  splashRadius: AppSizes.borderRadiusSmall,
                  onPressed: () {
                    controller.handlePaseteData();
                  },
                  icon: const Icon(Icons.paste_rounded,
                      color: AppColorTheme.black),
                ),
              ),
              Positioned(
                right: 4.0,
                top: 0.0,
                bottom: 0.0,
                child: GetBuilder<UpdateAddressController1>(
                  id: EnumUpdateAddress.INPUT_RECEIVE_ADDRESS,
                  builder: (_) {
                    return IconButton(
                      splashRadius: AppSizes.borderRadiusSmall,
                      onPressed: () {
                        controller.enableScan
                            ? controller.handleIconQRScanOnTap()
                            : controller.handleIcCloseOnTap();
                      },
                      icon: controller.enableScan
                          ? SvgPicture.asset(
                              AppAssets.globalIcScan,
                              color: AppColorTheme.black,
                            )
                          : const Icon(Icons.close, color: AppColorTheme.black),
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _GroupSelectFastAddressWidget extends GetView<UpdateAddressController1> {
  const _GroupSelectFastAddressWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            controller.handleTextShowAddresssActive();
          },
          minSize: 0,
          child: Text(
            'transferInMyAddresssStr'.tr,
            style: AppTextTheme.bodyText1.copyWith(
                color: AppColorTheme.accent, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: AppSizes.spaceNormal),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            controller.handleTextShowAddresssFavouriteOnTap();
          },
          minSize: 0,
          child: Text(
            'transferInRecieveFavouriteAddresssStr'.tr,
            style: AppTextTheme.bodyText1.copyWith(
                color: AppColorTheme.accent, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _GroupShowErrorWidget extends GetView<UpdateAddressController1> {
  const _GroupShowErrorWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.spaceSmall),
      padding: EdgeInsets.all(AppSizes.spaceMedium),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
          color: AppColorTheme.highlight20),
      child: Text(
        controller.noCoin
            ? controller.errorNoCoinStr()
            : 'address_not_avalible'.tr,
        style: AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black),
      ),
    );
  }
}
