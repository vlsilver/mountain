import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/asset_values.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/widget_global/global_input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../import_wallet_controller.dart';

class ImportWalletFormInputWidget extends GetView<ImportWalletController> {
  const ImportWalletFormInputWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () {
        controller.handleOnChangeInput();
      },
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GetBuilder<ImportWalletController>(
            id: EnumUpdateImportWallet.INPUT_TEXT_MNEMONIC,
            builder: (_) {
              return _InputMnemonicWidget();
            },
          ),
          SizedBox(
            height: AppSizes.spaceVeryLarge,
          ),
          GetBuilder<ImportWalletController>(
            id: EnumUpdateImportWallet.INPUT_TEXT_PASSWORD,
            builder: (_) {
              return GlobalInputSecurityWidget(
                  controller: _.passwordController,
                  validator: _.validatorPassword,
                  onTap: _.handleInputOnTap,
                  security: _.security,
                  hintText: 'create_password_hint_text'.tr,
                  onTapIcEye: _.handleIconEyePasswordOnTap);
            },
          ),
          SizedBox(
            height: AppSizes.spaceVeryLarge,
          ),
          GetBuilder<ImportWalletController>(
            id: EnumUpdateImportWallet.INPUT_TEXT_PASSWORD,
            builder: (_) {
              return GlobalInputSecurityWidget(
                  controller: _.passwordConfirmController,
                  validator: _.validatorConfirmPassword,
                  onTap: _.handleInputOnTap,
                  security: _.security,
                  hintText: 'create_confirm_password_hint_text'.tr,
                  onTapIcEye: _.handleIconEyePasswordOnTap);
            },
          ),
        ],
      ),
    );
  }
}

class _InputMnemonicWidget extends GetView<ImportWalletController> {
  const _InputMnemonicWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          controller: controller.mnemonicController,
          validator: (text) => controller.validatorMnemonic(),
          keyboardType: TextInputType.text,
          onTap: () {
            controller.handleInputOnTap();
          },
          onChanged: (value) {
            controller.handleInputMnemonicText();
            controller.handleOnChangeInput();
          },
          maxLines: null,
          style: AppTextTheme.bodyText1.copyWith(color: Colors.black),
          scrollController: null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFFDFDFD),
            isCollapsed: true,
            contentPadding: EdgeInsets.only(
              top: 20.0,
              bottom: 20.0,
              left: 20.0,
              right: 88.0,
            ),
            hintStyle:
                AppTextTheme.bodyText1.copyWith(color: Get.theme.hintColor),
            errorStyle:
                AppTextTheme.bodyText2.copyWith(color: AppColorTheme.error),
            hintText: 'root_Str'.tr,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
            ),
          ),
        ),
        Positioned(
          right: 0.0,
          top: 0.0,
          height: 61.0,
          child: Row(
            children: [
              IconButton(
                splashRadius: AppSizes.borderRadiusSmall,
                onPressed: controller.handleIconQRScanOnTap,
                icon: SvgPicture.asset(controller.icScan),
              ),
              IconButton(
                splashRadius: AppSizes.borderRadiusSmall,
                onPressed: () {
                  controller.handleIconEyeMnemonicOnTap();
                },
                icon: SvgPicture.asset(controller.securityMnemonic
                    ? AppAssets.globalIcEyeHidden
                    : AppAssets.globalIcEyeVisible),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
