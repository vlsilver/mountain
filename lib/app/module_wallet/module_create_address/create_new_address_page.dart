import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/asset_values.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'create_new_address_controller.dart';

class CreateNewAddressPage extends GetView<CreateNewAddressController> {
  const CreateNewAddressPage({
    Key? key,
    this.isBack = true,
    this.tab,
  }) : super(key: key);

  final bool isBack;
  final int? tab;

  @override
  Widget build(BuildContext context) {
    var _tab = 0;
    if (tab == null) {
      _tab = Get.arguments;
    } else {
      _tab = tab!;
    }
    return Material(
      color: AppColorTheme.focus,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusNode: controller.focusNode,
        onTap: () {
          controller.handleScreenOnTap();
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: AppSizes.spaceNormal,
            ),
            _AppBarWidget(isBack: isBack),
            SizedBox(height: AppSizes.spaceMedium),
            Expanded(
              child: DefaultTabController(
                  length: 2,
                  initialIndex: _tab,
                  child: Column(
                    children: [
                      TabBar(
                          indicatorWeight: 3.0,
                          indicatorColor: AppColorTheme.accent,
                          labelColor: AppColorTheme.accent,
                          labelStyle:
                              AppTextTheme.bodyText1.copyWith(fontSize: 18),
                          unselectedLabelColor: AppColorTheme.black60,
                          onTap: (index) {
                            controller.handleTabarOnTap(index: index);
                          },
                          tabs: [
                            Text('create_new'.tr),
                            Text('enter_accountStr'.tr),
                          ]),
                      Expanded(
                        child: TabBarView(children: [
                          _CreateNewAddressGroupWidget(isBack: isBack),
                          _ImportKeyGroupWidget(isBack: isBack),
                        ]),
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class _AppBarWidget extends GetView<CreateNewAddressController> {
  const _AppBarWidget({
    Key? key,
    this.isBack = true,
  }) : super(key: key);

  final bool isBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 24.0),
        SizedBox(
          height: 24.0,
          width: 24.0,
          child: isBack
              ? IconButton(
                  padding: EdgeInsets.all(0),
                  splashRadius: 12.0,
                  onPressed: () {
                    controller.handleIcBackOntap();
                  },
                  icon: Icon(Icons.arrow_back_ios),
                  color: AppColorTheme.accent,
                )
              : null,
        ),
        Expanded(
          child: Text('create_accountStr'.tr,
              style:
                  AppTextTheme.headline2.copyWith(color: AppColorTheme.black),
              textAlign: TextAlign.center),
        ),
        SizedBox(width: 48.0),
      ],
    );
  }
}

class _CreateNewAddressGroupWidget extends GetView<CreateNewAddressController> {
  const _CreateNewAddressGroupWidget({
    Key? key,
    this.isBack = true,
  }) : super(key: key);

  final bool isBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.spaceLarge),
      child: Column(
        children: [
          GetBuilder<CreateNewAddressController>(
            id: EnumUpdateAddAcount.NAME_ADDRESS,
            builder: (_) {
              return TextFormField(
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  _.handleTextFormFieldAccountNameOnChange(input: value);
                },
                onTap: _.handleOnTapName,
                style: AppTextTheme.bodyText1.copyWith(color: Colors.black),
                textAlignVertical: TextAlignVertical.center,
                maxLength: 30,
                decoration: InputDecoration(
                  errorMaxLines: 2,
                  filled: true,
                  fillColor: AppColorTheme.card,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(20),
                  hintStyle: AppTextTheme.bodyText1
                      .copyWith(color: Get.theme.hintColor),
                  errorStyle: AppTextTheme.bodyText2
                      .copyWith(color: AppColorTheme.error),
                  hintText: 'hint_account'.tr,
                  errorText: _.isErrorName,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadiusSmall),
                  ),
                ),
              );
            },
          ),
          Expanded(child: SizedBox()),
          GetBuilder<CreateNewAddressController>(
            id: EnumUpdateAddAcount.BUTTON_ACCOUNT_NAME,
            builder: (_) {
              return GlobalButtonWidget(
                  name: 'global_create'.tr,
                  type: _.isActiveButtonNew
                      ? ButtonType.ACTIVE
                      : ButtonType.DISABLE,
                  onTap: () {
                    controller.handleButtonCreateOntap(isBack);
                  });
            },
          )
        ],
      ),
    );
  }
}

class _ImportKeyGroupWidget extends GetView<CreateNewAddressController> {
  const _ImportKeyGroupWidget({
    Key? key,
    this.isBack = true,
  }) : super(key: key);

  final bool isBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.spaceLarge),
      child: Column(
        children: [
          Text(
            'importedAccount'.tr,
            style:
                AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black60),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.spaceLarge),
          GetBuilder<CreateNewAddressController>(
            id: EnumUpdateAddAcount.IMPORT_KEY,
            builder: (_) {
              return TextFormField(
                keyboardType: TextInputType.text,
                controller: _.privateKeyController,
                onTap: _.handleOnTapImportKey,
                onChanged: (value) {
                  controller.handleTextFormFieldInputKeyOnChange(input: value);
                },
                style: AppTextTheme.bodyText1.copyWith(color: Colors.black),
                textAlignVertical: TextAlignVertical.center,
                maxLines: null,
                decoration: InputDecoration(
                  errorMaxLines: 2,
                  filled: true,
                  fillColor: AppColorTheme.card,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(20),
                  hintStyle: AppTextTheme.bodyText1
                      .copyWith(color: Get.theme.hintColor),
                  errorStyle: AppTextTheme.bodyText2
                      .copyWith(color: AppColorTheme.error),
                  hintText: controller.blockChainId == BlockChainModel.piTestnet
                      ? 'keyChain_seedphrase'.tr
                      : 'keyChain'.tr,
                  errorText:
                      _.privateKeyState == EnumPrivateKeyStatus.NOT_AVAILBLE
                          ? 'key_notAvai'.tr
                          : _.privateKeyState == EnumPrivateKeyStatus.EXITED
                              ? 'address_exited'.tr
                              : null,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadiusSmall),
                  ),
                ),
              );
            },
          ),
          Expanded(child: SizedBox()),
          CupertinoButton(
            onPressed: controller.handleIconQRScanOnTap,
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppAssets.globalIcScan,
                  color: AppColorTheme.accent,
                ),
                SizedBox(width: AppSizes.spaceNormal),
                Text(
                  'qr_scan'.tr,
                  style: AppTextTheme.headline2
                      .copyWith(color: AppColorTheme.accent),
                )
              ],
            ),
          ),
          SizedBox(height: AppSizes.spaceLarge),
          GetBuilder<CreateNewAddressController>(
            id: EnumUpdateAddAcount.BUTTON_INPUT_KEY,
            builder: (_) {
              return GlobalButtonWidget(
                  name: 'global_enter'.tr,
                  type: _.isActiveButtonInput
                      ? ButtonType.ACTIVE
                      : ButtonType.DISABLE,
                  onTap: () {
                    controller.handleButtonCreateFromPrivateKeyOnTap(isBack);
                  });
            },
          )
        ],
      ),
    );
  }
}
