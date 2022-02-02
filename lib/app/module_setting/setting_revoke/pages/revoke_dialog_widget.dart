import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogWarningRevokeWidget extends StatelessWidget {
  const DialogWarningRevokeWidget({
    Key? key,
    required this.symbol,
    required this.onTap,
  }) : super(key: key);

  final String symbol;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceLarge),
        child: Material(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
          color: AppColorTheme.focus,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppSizes.spaceSmall,
                    right: AppSizes.spaceSmall,
                  ),
                  child: SizedBox(
                    height: 32.0,
                    width: 32.0,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      iconSize: 32.0,
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.close),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.spaceLarge),
                child: Column(
                  children: [
                    Text(
                      'dialogTitleStr'.tr,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.headline2.copyWith(
                          color: AppColorTheme.error,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: AppSizes.spaceLarge),
                    Text(
                      'revoke_dialog_detail'.trParams({'symbol': symbol})!,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.bodyText1
                          .copyWith(color: AppColorTheme.black60),
                    ),
                    SizedBox(height: AppSizes.spaceLarge),
                    GlobalButtonWidget(
                        name: 'revoke_link'.tr,
                        type: ButtonType.FOCUS,
                        onTap: () {
                          onTap();
                        }),
                    SizedBox(height: AppSizes.spaceLarge),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
