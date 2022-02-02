import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/asset_values.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:base_source/app/module_wallet/widget/input_widget.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/routes/pages_routes.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'update_address_send_controller.dart';

class SendNavigatorPage extends StatelessWidget {
  const SendNavigatorPage({
    Key? key,
    required this.isFullScreen,
  }) : super(key: key);

  final bool isFullScreen;

  @override
  Widget build(BuildContext context) {
    return isFullScreen
        ? Navigator(
            key: Get.nestedKey(AppPages.NAVIGATOR_KEY_SEND),
            initialRoute: AppRoutes.UPDATE_ADDRESS_SEND,
            onGenerateRoute: (setting) {
              return AppPages.pageNavigatorSend(
                setting.name!,
                isFullScreen,
              );
            },
          )
        : GlobalBottomSheetLayoutWidget(
            child: Navigator(
              key: Get.nestedKey(AppPages.NAVIGATOR_KEY_SEND),
              initialRoute: AppRoutes.UPDATE_ADDRESS_SEND,
              onGenerateRoute: (setting) {
                return AppPages.pageNavigatorSend(setting.name!, isFullScreen);
              },
            ),
          );
  }
}

class UpdateAddressSendPage extends GetView<UpdateAddressSendController> {
  const UpdateAddressSendPage({
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
                  ? SizedBox(height: AppSizes.spaceNormal)
                  : SizedBox(),
              !isFullScreen
                  ? AppBarWidget(
                      title: 'select_address'.tr,
                      onTap: () {
                        Get.back();
                      })
                  : const SizedBox(),
              SizedBox(height: AppSizes.spaceMedium),
              _InputAddressSendWidget(),
              SizedBox(height: AppSizes.spaceMedium),
              _InputAddressReceiveWidget(),
              SizedBox(height: AppSizes.spaceLarge),
              _GroupSelectFastAddressWidget(),
              Expanded(child: SizedBox()),
              GetBuilder<UpdateAddressSendController>(
                id: EnumUpdateAddress.GROUP_ERROR,
                builder: (_) {
                  if (_.valid) {
                    return SizedBox();
                  } else {
                    return _GroupShowErrorWidget();
                  }
                },
              ),
              GetBuilder<UpdateAddressSendController>(
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
              SizedBox(height: AppSizes.spaceVeryLarge),
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

class _InputAddressSendWidget extends GetView<UpdateAddressSendController> {
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
        SizedBox(width: AppSizes.spaceMedium),
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
                            child: GetBuilder<UpdateAddressSendController>(
                                id: EnumUpdateAddress.ADDRESS_SENDER,
                                builder: (_) {
                                  return GetBuilder<WalletController>(
                                    id: EnumUpdateWallet.CURRENCY_ACTIVE,
                                    builder: (walletController) {
                                      return Row(
                                        children: [
                                          Text(
                                            _.sendController.addressSender.name,
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
                                              _.sendController.addressSender
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
                  SizedBox(
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

class _InputAddressReceiveWidget extends GetView<UpdateAddressSendController> {
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
        SizedBox(width: AppSizes.spaceMedium),
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
                  icon: Icon(Icons.paste_rounded, color: AppColorTheme.black),
                ),
              ),
              Positioned(
                right: 4.0,
                top: 0.0,
                bottom: 0.0,
                child: GetBuilder<UpdateAddressSendController>(
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
                          : Icon(Icons.close, color: AppColorTheme.black),
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

class _GroupSelectFastAddressWidget
    extends GetView<UpdateAddressSendController> {
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
        SizedBox(height: AppSizes.spaceNormal),
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

class _GroupShowErrorWidget extends GetView<UpdateAddressSendController> {
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
