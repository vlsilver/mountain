import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'global_logo_widget.dart';

class GlobalErrorWidget extends StatelessWidget {
  const GlobalErrorWidget({
    Key? key,
    this.title,
  }) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlobalLogoWidget(
            height: 64.0,
          ),
          SizedBox(height: AppSizes.spaceNormal),
          Text(
            title ?? 'global_load_data_failure'.tr,
            textAlign: TextAlign.center,
            style: AppTextTheme.headline2.copyWith(color: AppColorTheme.accent),
          )
        ],
      ),
    );
  }
}
