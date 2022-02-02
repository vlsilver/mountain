import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_setting/setting_change/setting_change_contact/setting_change_contact_controller.dart';
import 'package:base_source/app/module_setting/widget/layout_setting_page.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SettingChangeContactDetailPage
    extends GetView<SettingChangeContactController> {
  const SettingChangeContactDetailPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutSettingDetailWidget(
        title: 'detail_Str'.tr,
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppSizes.spaceMedium,
              vertical: AppSizes.spaceVeryLarge),
          child: _DetailItemWidget(),
        ));
  }
}

class _DetailItemWidget extends GetView<SettingChangeContactController> {
  const _DetailItemWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GetBuilder<SettingChangeContactController>(
          id: EnumUpdateSettingContact.AVATAR,
          builder: (_) {
            return SvgPicture.asset(controller.addressDetail.avatarAddress,
                height: 56);
          },
        ),
        SizedBox(height: AppSizes.spaceVeryLarge),
        Text(
          'name_Str'.tr,
          style: AppTextTheme.bodyText1.copyWith(
            color: AppColorTheme.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSizes.spaceVerySmall),
        GetBuilder<SettingChangeContactController>(
          id: EnumUpdateSettingContact.NAME,
          builder: (_) {
            return Text(
              controller.addressDetail.name,
              style: AppTextTheme.bodyText1.copyWith(
                color: AppColorTheme.accent,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
        SizedBox(height: AppSizes.spaceMedium),
        Divider(color: AppColorTheme.accent60, thickness: 1.0),
        SizedBox(height: AppSizes.spaceLarge),
        Row(
          children: [
            Text(
              'address_Str'.tr,
              style: AppTextTheme.bodyText1.copyWith(
                color: AppColorTheme.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
                onPressed: controller.handleIconCopyOntap,
                splashRadius: AppSizes.spaceMedium,
                icon: Icon(
                  Icons.file_copy_outlined,
                  color: AppColorTheme.accent,
                )),
          ],
        ),
        SizedBox(height: AppSizes.spaceVerySmall),
        Text(
          controller.addressDetail.address,
          style: AppTextTheme.bodyText1.copyWith(
            color: AppColorTheme.accent,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSizes.spaceMedium),
        Divider(color: AppColorTheme.accent60, thickness: 1.0),
        Expanded(child: SizedBox()),
        GlobalButtonWidget(
            name: 'edit_Str'.tr,
            type: ButtonType.ACTIVE,
            onTap: controller.handleButtonEditOnTap)
      ],
    );
  }
}
