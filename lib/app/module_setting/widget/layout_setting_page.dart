import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_setting/widget/hero_logo_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'hero_title_widget.dart';

class LayoutSettingDetailWidget extends StatelessWidget {
  const LayoutSettingDetailWidget({
    Key? key,
    required this.title,
    required this.body,
    this.action = false,
    this.onTapAction,
  }) : super(key: key);

  final String title;
  final Widget body;
  final bool action;
  final Function? onTapAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorTheme.backGround2,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 80.0,
        backgroundColor: AppColorTheme.backGround2,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          splashRadius: AppSizes.spaceMedium,
          iconSize: 24.0,
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 24.0,
            color: AppColorTheme.accent,
          ),
        ),
        actions: [
          action
              ? CupertinoButton(
                  onPressed: () {
                    onTapAction!();
                  },
                  padding: EdgeInsets.only(right: 8.0),
                  minSize: 0.0,
                  child: Text(
                    'global_clear_all'.tr,
                    textAlign: TextAlign.center,
                    style: AppTextTheme.bodyText2.copyWith(
                        color: AppColorTheme.textAction,
                        fontWeight: FontWeight.w600),
                  ),
                )
              : SizedBox(),
        ],
        title: Column(
          children: [
            HeroLogoWidget(),
            HeroTitleWidget(
              title: title,
              style:
                  AppTextTheme.headline2.copyWith(color: AppColorTheme.accent),
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
