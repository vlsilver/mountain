import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_setting/setting_change/setting_change_controller.dart';
import 'package:base_source/app/module_setting/widget/layout_setting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingChangeGeneralPage extends GetView<SettingChangeController> {
  const SettingChangeGeneralPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutSettingDetailWidget(
      title: 'overview'.tr,
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.only(
          top: AppSizes.spaceLarge,
          left: AppSizes.spaceLarge,
          right: AppSizes.spaceLarge,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TitleWidget(
              title: 'protect_walltet'.tr,
              desc: 'fiatValue'.tr,
            ),
            SizedBox(height: AppSizes.spaceMedium),
            GetBuilder<SettingChangeController>(
                id: EnumUpdateSettingChange.CURRENCY,
                builder: (_) {
                  return _ChangeSelectItemWidget(
                      select: _.currencyActive.currencySelectFormat,
                      onTap: _.handleBoxSelectCurrencyOnTap);
                }),
            SizedBox(height: AppSizes.spaceMedium),
            _TitleWidget(
              title: 'current_language'.tr,
              desc: 'app_translate'.tr,
            ),
            SizedBox(height: AppSizes.spaceMedium),
            GetBuilder<SettingChangeController>(
                id: EnumUpdateSettingChange.LANGUAGE,
                builder: (_) {
                  return _ChangeSelectItemWidget(
                      select: _.languageActive.languageDesc,
                      onTap: _.handleBoxSelectLanguageOnTap);
                }),
          ],
        ),
      )),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({
    Key? key,
    required this.title,
    required this.desc,
  }) : super(key: key);

  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextTheme.bodyText1.copyWith(
              color: AppColorTheme.black80, fontWeight: FontWeight.bold),
        ),
        Text(
          desc,
          style: AppTextTheme.bodyText2.copyWith(
            color: AppColorTheme.black60,
          ),
        ),
      ],
    );
  }
}

class _ChangeSelectItemWidget extends StatelessWidget {
  const _ChangeSelectItemWidget({
    required this.onTap,
    required this.select,
    Key? key,
  }) : super(key: key);

  final Function onTap;
  final String select;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
        height: 64.0,
        decoration: BoxDecoration(
          color: AppColorTheme.focus,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.borderRadiusSmall),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                select,
                style:
                    AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black),
              ),
            ),
            Icon(Icons.keyboard_arrow_down_outlined)
          ],
        ),
      ),
    );
  }
}
