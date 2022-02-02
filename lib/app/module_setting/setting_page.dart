import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_setting/setting_controller.dart';
import 'package:base_source/app/module_setting/widget/hero_logo_widget.dart';
import 'package:base_source/app/module_setting/widget/hero_title_widget.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final settingNames = <String>[
      'revoke_list'.tr,
      'history_transaction'.tr,
      'adjust_setting'.tr,
      'term'.tr,
      'privacy_policy'.tr,
      'contact1'.tr,
      'sign_out'.tr,
    ];
    return Scaffold(
      backgroundColor: AppColorTheme.backGround2,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Column(
          children: [
            HeroLogoWidget(),
            Text(
              'titleSetting'.tr,
              style: AppTextTheme.title,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        elevation: 0,
      ),
      body: GetBuilder<WalletController>(
          id: EnumUpdateWallet.PAGE,
          builder: (_) {
            if (!_.isLoadSuccess) {
              return Center(child: CupertinoActivityIndicator());
            }
            return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: settingNames.length,
                itemBuilder: (context, index) {
                  return _ItemSettingWidget(
                    index: index,
                    title: settingNames[index],
                  );
                });
          }),
    );
  }
}

class _ItemSettingWidget extends GetView<SettingController> {
  const _ItemSettingWidget({
    Key? key,
    required this.index,
    required this.title,
  }) : super(key: key);

  final int index;
  final String title;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        controller.handleItemSettingOnTap(index);
      },
      child: Container(
        height: 64.0,
        margin: EdgeInsets.symmetric(
          horizontal: AppSizes.spaceLarge,
          vertical: AppSizes.spaceVerySmall,
        ),
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.spaceMedium, vertical: AppSizes.spaceMedium),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
            color: AppColorTheme.focus),
        child: Row(
          children: [
            Expanded(
                child: HeroTitleWidget(
                    title: title,
                    align: TextAlign.left,
                    style: AppTextTheme.bodyText1.copyWith(
                        color: index == 6
                            ? AppColorTheme.delete
                            : AppColorTheme.black80))),
            index == 6
                ? Image.asset('assets/setting/ic_logout.png')
                : controller.hasDetail(index)
                    ? Icon(
                        Icons.arrow_right,
                        size: 32.0,
                        color: AppColorTheme.black60,
                      )
                    : SizedBox()
          ],
        ),
      ),
    );
  }
}
