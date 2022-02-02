import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalDialogNotiWidget extends StatelessWidget {
  const GlobalDialogNotiWidget({
    Key? key,
    required this.title,
    required this.desc,
    this.error = false,
  }) : super(key: key);

  final String title;
  final String desc;
  final bool error;

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
                      title,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.body.copyWith(
                          color: error
                              ? AppColorTheme.error
                              : AppColorTheme.success,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: AppSizes.spaceLarge),
                    Text(
                      desc,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.bodyText1
                          .copyWith(color: AppColorTheme.black60),
                    ),
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
