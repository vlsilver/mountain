import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_setting/setting_change/setting_change_contact/setting_change_contact_controller.dart';
import 'package:base_source/app/module_setting/widget/layout_setting_page.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:base_source/app/widget_global/global_input_widget.dart';
import 'package:base_source/app/widget_global/global_layout_builder_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SettingChangeContactEditPage
    extends GetView<SettingChangeContactController> {
  const SettingChangeContactEditPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutSettingDetailWidget(
        title: 'editInfo_Str'.tr,
        body: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusNode: controller.focusNode,
          onTap: controller.handleOnTapScreen,
          child: Padding(
            padding: EdgeInsets.only(
              left: AppSizes.spaceMedium,
              right: AppSizes.spaceMedium,
              top: AppSizes.spaceMedium,
              bottom: AppSizes.spaceVeryLarge,
            ),
            child: GlobalLayoutBuilderWidget(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'name_Str'.tr,
                    style: AppTextTheme.bodyText1.copyWith(
                      color: AppColorTheme.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceNormal),
                  GetBuilder<SettingChangeContactController>(
                    id: EnumUpdateSettingContact.NAME_EDIT,
                    builder: (_) {
                      return GlobalInputWidget(
                        hintText: _.addressDetail.name,
                        textInputType: TextInputType.name,
                        controller: _.nameController,
                        maxLength: 30,
                        onTap: _.handleOnTapName,
                        color: AppColorTheme.focus,
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
                  SizedBox(height: AppSizes.spaceMedium),
                  Wrap(
                    spacing: AppSizes.spaceMedium,
                    runSpacing: AppSizes.spaceMedium,
                    children: List.generate(8, (index) => index)
                        .map((index) =>
                            GetBuilder<SettingChangeContactController>(
                                id: index,
                                builder: (_) {
                                  return CupertinoButton(
                                    onPressed: () {
                                      _.handleAvatarOnTap(index);
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
                  Expanded(child: SizedBox(height: AppSizes.spaceNormal)),
                  GlobalButtonWidget(
                      name: 'save_Str'.tr,
                      type: ButtonType.ACTIVE,
                      onTap: controller.handleButtonSaveOnTap)
                ],
              ),
            ),
          ),
        ));
  }
}
