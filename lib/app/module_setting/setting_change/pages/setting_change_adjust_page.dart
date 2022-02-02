import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_setting/setting_change/setting_change_controller.dart';
import 'package:base_source/app/module_setting/widget/hero_title_widget.dart';
import 'package:base_source/app/module_setting/widget/layout_setting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingChangePage extends GetView<SettingChangeController> {
  const SettingChangePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final titles = <String>[
      'overview'.tr,
      'security_privacy'.tr,
      'account'.tr,
    ];

    final descs = <String>[
      'convertCurrency'.tr,
      'privacy_setting'.tr,
      'crud_app'.tr,
    ];
    return LayoutSettingDetailWidget(
      title: 'adjustSettings'.tr,
      body: ListView.builder(
        itemCount: titles.length + 1,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == titles.length) {
            return SizedBox(height: 68.0);
          }

          return _ItemSettingWidget(
            index: index,
            title: titles[index],
            desc: descs[index],
          );
        },
      ),
    );
  }
}

class _ItemSettingWidget extends GetView<SettingChangeController> {
  const _ItemSettingWidget({
    Key? key,
    required this.index,
    required this.title,
    required this.desc,
  }) : super(key: key);

  final int index;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        controller.handleItemSettingOnTap(index);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppSizes.spaceMedium,
          vertical: AppSizes.spaceVerySmall,
        ),
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.spaceMedium, vertical: AppSizes.spaceMedium),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
            color: AppColorTheme.focus),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeroTitleWidget(
                    title: title,
                    align: TextAlign.left,
                    style: AppTextTheme.bodyText1.copyWith(
                        color: AppColorTheme.black80,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    desc,
                    style: AppTextTheme.bodyText2.copyWith(
                      color: AppColorTheme.black60,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSizes.spaceMedium),
            Icon(
              Icons.arrow_right_outlined,
              size: 32.0,
              color: AppColorTheme.black60,
            )
          ],
        ),
      ),
    );
  }
}
