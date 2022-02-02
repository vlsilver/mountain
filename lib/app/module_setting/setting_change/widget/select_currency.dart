import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/services/setting_services.dart';
import 'package:base_source/app/module_setting/setting_change/setting_change_controller.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectCurrencyWidget extends GetView<SettingChangeController> {
  const SelectCurrencyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlobalBottomSheetLayoutWidget(
      height: Get.height * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
        child: Column(
          children: [
            SizedBox(height: AppSizes.spaceSmall),
            Text(
              'baseCurrency'.tr,
              style:
                  AppTextTheme.headline2.copyWith(color: AppColorTheme.black),
            ),
            SizedBox(height: AppSizes.spaceLarge),
            Expanded(
              child: ListView.builder(
                  itemCount: controller.currencys.length,
                  itemBuilder: (context, index) {
                    final currency = controller.currencys[index];
                    return _ItemCurrencyWidget(currency: currency);
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
    required this.currency,
  }) : super(key: key);

  final Currency currency;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingChangeController>(
      id: currency.locale,
      builder: (_) {
        return CupertinoButton(
          onPressed: () {
            _.handleBoxCurencyItemOnTap(currency);
          },
          padding: EdgeInsets.zero,
          child: Container(
              margin: EdgeInsets.symmetric(vertical: AppSizes.spaceVerySmall),
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceMedium),
              height: 64.0,
              decoration: BoxDecoration(
                  color: AppColorTheme.backGround,
                  borderRadius:
                      BorderRadius.circular(AppSizes.borderRadiusSmall)),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(currency.currency,
                              style: AppTextTheme.bodyText1.copyWith(
                                  color: AppColorTheme.accent,
                                  fontWeight: FontWeight.bold)),
                          Text(currency.currencyDesc,
                              style: AppTextTheme.bodyText2.copyWith(
                                color: AppColorTheme.black,
                              ))
                        ],
                      ),
                    ),
                    _.isCurrency(currency.locale)
                        ? Icon(
                            Icons.check_circle_outline,
                            color: AppColorTheme.toggleableActiveColor,
                          )
                        : SizedBox()
                  ],
                ),
              )),
        );
      },
    );
  }
}
