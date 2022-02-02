import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_setting/setting_change/setting_change_password/setting_change_password_controller.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:base_source/app/widget_global/global_input_widget.dart';
import 'package:base_source/app/widget_global/global_layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingChangePasswordPage
    extends GetView<SettingChangePasswordController> {
  const SettingChangePasswordPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GlobalBottomSheetLayoutWidget(
      child: InkWell(
        focusNode: controller.focusNode,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          controller.handleScreenOnTap();
        },
        child: GlobalLayoutBuilderWidget(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppSizes.spaceNormal),
                Text(
                  'changePass'.tr,
                  style: AppTextTheme.headline2
                      .copyWith(color: AppColorTheme.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.spaceMedium),
                Text(
                  'requiredField'.tr,
                  style: AppTextTheme.bodyText1
                      .copyWith(color: AppColorTheme.black),
                ),
                SizedBox(height: AppSizes.spaceMedium),
                _InputPasswordWidget(),
                Expanded(child: SizedBox(height: AppSizes.spaceMedium)),
                GetBuilder<SettingChangePasswordController>(
                  id: EnumUpdateSettingChangePassword.BUTTON,
                  builder: (_) {
                    return GlobalButtonWidget(
                        name: 'submitChange'.tr,
                        type: _.isActiveButton
                            ? ButtonType.ACTIVE
                            : ButtonType.DISABLE,
                        onTap: controller.handleButtonOnTap);
                  },
                ),
                SizedBox(height: AppSizes.spaceMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InputPasswordWidget extends GetView<SettingChangePasswordController> {
  const _InputPasswordWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingChangePasswordController>(
      id: EnumUpdateSettingChangePassword.INPUT_TEXT,
      builder: (_) {
        return Form(
          autovalidateMode: AutovalidateMode.disabled,
          onChanged: () {
            _.handleOnChangeInput();
          },
          key: controller.formKey,
          child: Column(
            children: [
              GlobalInputSecurityWidget(
                  controller: _.passwordOldController,
                  validator: _.validatorPasswordOld,
                  onTap: _.handleInputOnTap,
                  security: _.security,
                  hintText: 'oldPass'.tr,
                  color: AppColorTheme.backGround,
                  onTapIcEye: _.handleIconEyeOnTap),
              SizedBox(height: AppSizes.spaceMedium),
              GlobalInputSecurityWidget(
                  controller: _.passwordNewController,
                  validator: _.validatorPasswordNew,
                  onTap: _.handleInputOnTap,
                  security: _.security,
                  hintText: 'newPass'.tr,
                  color: AppColorTheme.backGround,
                  onTapIcEye: _.handleIconEyeOnTap),
              SizedBox(height: AppSizes.spaceMedium),
              GlobalInputSecurityWidget(
                  controller: _.passwordConfirmController,
                  validator: _.validatorConfirmPassword,
                  onTap: _.handleInputOnTap,
                  security: _.security,
                  hintText: 'confirmPass'.tr,
                  color: AppColorTheme.backGround,
                  onTapIcEye: _.handleIconEyeOnTap),
            ],
          ),
        );
      },
    );
  }
}
