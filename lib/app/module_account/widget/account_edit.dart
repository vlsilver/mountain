import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_account/account_controller.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:base_source/app/widget_global/global_input_widget.dart';
import 'package:base_source/app/widget_global/global_layout_builder_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AccountEditWidget extends GetView<AccountController> {
  const AccountEditWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlobalBottomSheetLayoutWidget(
      height: Get.height * 0.85,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusNode: controller.focusNode,
        onTap: controller.handleOnTapScreen,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
          child: GlobalLayoutBuilderWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppSizes.spaceSmall),
                Text(
                  'editInfo_Str'.tr,
                  textAlign: TextAlign.center,
                  style: AppTextTheme.headline2
                      .copyWith(color: AppColorTheme.black),
                ),
                SizedBox(height: AppSizes.spaceLarge),
                Text(
                  'name_Str'.tr,
                  style: AppTextTheme.bodyText1.copyWith(
                    color: AppColorTheme.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSizes.spaceNormal),
                GetBuilder<AccountController>(
                  id: EnumAccountPage.NAME_EDIT,
                  builder: (_) {
                    return GlobalInputWidget(
                      hintText: _.addressEdit.name,
                      textInputType: TextInputType.name,
                      controller: _.nameController,
                      color: AppColorTheme.card,
                      onTap: _.handleOnTapName,
                      maxLength: 30,
                      errorText: _.isErrorName,
                    );
                  },
                ),
                SizedBox(height: AppSizes.spaceNormal),
                Text(
                  'avatar_Str'.tr,
                  style: AppTextTheme.bodyText1.copyWith(
                    color: AppColorTheme.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSizes.spaceNormal),
                Wrap(
                  spacing: AppSizes.spaceMedium,
                  runSpacing: AppSizes.spaceMedium,
                  children: List.generate(8, (index) => index)
                      .map((index) => GetBuilder<AccountController>(
                          id: index,
                          builder: (_) {
                            return CupertinoButton(
                              onPressed: () {
                                _.handleAvatarOnTap(avatarIndex: index);
                              },
                              padding: EdgeInsets.zero,
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: _.isAvatarActive(index)
                                        ? Border.all(
                                            color: AppColorTheme.error,
                                            width: 2.0)
                                        : null),
                                child: SvgPicture.asset(
                                    'assets/global/avatar/avatar_$index.svg'),
                              ),
                            );
                          }))
                      .toList(),
                ),
                Expanded(child: SizedBox()),
                GlobalButtonWidget(
                    name: 'save_Str'.tr,
                    type: ButtonType.ACTIVE,
                    onTap: controller.handleButtonSaveOnTap),
                SizedBox(height: AppSizes.spaceNormal),
                GlobalButtonWidget(
                    name: 'global_cancel'.tr,
                    type: ButtonType.ERROR,
                    onTap: controller.handleButtonCancelOnTap),
                SizedBox(height: AppSizes.spaceVeryLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
