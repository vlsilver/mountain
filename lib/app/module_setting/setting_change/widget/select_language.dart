import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/services/setting_services.dart';
import 'package:base_source/app/module_setting/setting_change/setting_change_controller.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectLanguageWidget extends GetView<SettingChangeController> {
  const SelectLanguageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlobalBottomSheetLayoutWidget(
      height: Get.height * 0.85,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
        child: Column(
          children: [
            SizedBox(height: AppSizes.spaceSmall),
            Text(
              'titleLanguageStr'.tr,
              style:
                  AppTextTheme.headline2.copyWith(color: AppColorTheme.black),
            ),
            SizedBox(height: AppSizes.spaceLarge),
            Expanded(
              child: ListView.builder(
                  itemCount: controller.languages.length,
                  itemBuilder: (context, index) {
                    final language = controller.languages[index];
                    return _ItemCurrencyWidget(language: language);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemCurrencyWidget extends StatelessWidget {
  const _ItemCurrencyWidget({
    Key? key,
    required this.language,
  }) : super(key: key);

  final Language language;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingChangeController>(
      id: language.language,
      builder: (_) {
        return CupertinoButton(
          onPressed: () {
            _.handleBoxLanguageItemOnTap(language);
          },
          padding: EdgeInsets.zero,
          child: Container(
              margin: EdgeInsets.symmetric(vertical: AppSizes.spaceVerySmall),
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceMedium,
                  vertical: AppSizes.spaceSmall),
              height: 64.0,
              decoration: BoxDecoration(
                  color: AppColorTheme.backGround,
                  borderRadius:
                      BorderRadius.circular(AppSizes.borderRadiusSmall)),
              child: Row(
                children: [
                  Expanded(
                    child: Text(language.languageDesc,
                        style: AppTextTheme.bodyText1.copyWith(
                            color: AppColorTheme.accent,
                            fontWeight: FontWeight.bold)),
                  ),
                  _.isLanguage(language.language)
                      ? Icon(
                          Icons.check_circle_outline,
                          color: AppColorTheme.toggleableActiveColor,
                        )
                      : SizedBox()
                ],
              )),
        );
      },
    );
  }
}
