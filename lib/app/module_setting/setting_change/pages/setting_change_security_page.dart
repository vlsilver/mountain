import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_setting/setting_change/setting_change_controller.dart';
import 'package:base_source/app/module_setting/widget/layout_setting_page.dart';
import 'package:base_source/app/widget_global/global_switch_touchId_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingChangeSecurityPage extends GetView<SettingChangeController> {
  const SettingChangeSecurityPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutSettingDetailWidget(
      title: 'security_privacy'.tr,
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
            Text(
              '1. ' + 'titleSecurity1'.tr,
              style:
                  AppTextTheme.headline2.copyWith(color: AppColorTheme.accent),
            ),
            SizedBox(height: AppSizes.spaceNormal),
            _TitleWidget(
              title: 'protect_walltet'.tr,
              desc: 'desSecurity'.tr,
            ),
            _ButtonWidget(
              name: 'btnShowSeedphraseStr'.tr,
              onTap: controller.handleButtonShowSeedPhraseOnTap,
            ),
            _TitleWidget(
              title: 'password'.tr,
              desc: 'choosePassword'.tr,
            ),
            _ButtonWidget(
                name: 'btnChangePassowrdStr'.tr,
                onTap: controller.handleButtonChangePasswordOnTap),
            GetBuilder<SettingChangeController>(
              id: EnumUpdateSettingChange.SWITCH_TOUCH_ID,
              builder: (_) {
                return GlobalSwitchTouchIdWidget(
                  onChange: _.handleSwitchTouchIdOnChange,
                  value: _.biometricState,
                  style: AppTextTheme.bodyText1.copyWith(
                      fontWeight: FontWeight.w600, color: AppColorTheme.black),
                );
              },
            ),
            _TitleWidget(
              title: 'show_privateKey'.tr,
              desc: 'keyForAccount'.tr,
            ),
            _ButtonWidget(
              name: 'btnShowPrivateKey'.tr,
              onTap: controller.handleButtonChangeShowPrivateKeyOnTap,
            ),
          ],
        ),
      )),
    );
  }
}

class _ButtonWidget extends StatelessWidget {
  const _ButtonWidget({
    Key? key,
    required this.onTap,
    required this.name,
  }) : super(key: key);

  final Function onTap;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: AppSizes.spaceNormal, bottom: AppSizes.spaceMedium),
      child: CupertinoButton(
        onPressed: () {
          onTap();
        },
        color: AppColorTheme.accent,
        minSize: 24.0,
        borderRadius: BorderRadius.circular(AppSizes.spaceNormal),
        padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
        child: Text(name,
            style:
                AppTextTheme.bodyText2.copyWith(fontWeight: FontWeight.w600)),
      ),
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
