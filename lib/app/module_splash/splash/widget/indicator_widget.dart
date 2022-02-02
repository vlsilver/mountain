import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../splash_controller.dart';

class SplashIndicatorWidget extends GetView<SplashController> {
  const SplashIndicatorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: AppSizes.sizeGroupIndicator.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: List.filled(
              controller.listIntroWidget.length,
              Container(
                height: AppSizes.sizeIndicatorSplash.height,
                width: AppSizes.sizeIndicatorSplash.width,
                decoration: BoxDecoration(
                  color: AppColorTheme.disable,
                  borderRadius:
                      BorderRadius.circular(AppSizes.borderRadiusVeryLarge),
                ),
              ),
            ),
          ),
        ),
        Obx(() => Positioned(
              left: controller.leftSpaceOfIndicatorActive.value,
              child: _IndcatorActive(),
            )),
      ],
    );
  }
}

class _IndcatorActive extends StatelessWidget {
  const _IndcatorActive({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.sizeIndicatorSplash.height,
      width: AppSizes.sizeIndicatorSplash.width,
      decoration: BoxDecoration(
        color: AppColorTheme.focus,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusVeryLarge),
      ),
    );
  }
}
