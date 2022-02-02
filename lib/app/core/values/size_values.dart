import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSizes {
  ///Size(414.0, 896.0)
  static const sizeDesign = Size(414.0, 896.0);

  ///4.00 pixel
  static const spaceVerySmall = 4.0;

  ///8.00 pixel
  static const spaceSmall = 8.0;

  ///12.00 pixel
  static const spaceNormal = 12.0;

  ///16.00 pixel
  static const spaceMedium = 16.0;

  ///24.00 pixel
  static const spaceLarge = 24.0;

  ///32.00 pixel
  static const spaceVeryLarge = 32.0;

  ///40.00 pixel
  static const spaceMaxMedium = 40.0;

  ///64.00 pixel
  static const spaceMax = 48.0;

  ///8.00 pixel
  static const borderRadiusSmall = 8.0;

  ///12.00 pixel
  static const borderRadiusNormal = 12.0;

  ///16.00 pixel
  static const borderRadiusMedium = 16.0;

  ///24.00 pixel
  static const borderRadiusLarge = 24.0;

  ///30.00 pixel
  static const borderRadiusVeryLarge = 30.0;

  ///Size(double.infinity, 56.0)
  static const sizeButtonWidget = Size(double.infinity, 56.0);

  ///Size(16.0, 6.0)
  static const sizeIndicatorSplash = Size(16.0, 6.0);

  ///Size(68.0.0, 6.0)
  static const sizeGroupIndicator = Size(68.0, 6.0);

  ///Size(18.0, 18.0)
  static const sizeIndicatorStepSetupWallet = Size(18.0, 18.0);

  ///Size(Get.width * 2/3, 18.0)
  static final sizeGroupIndicatorStepSetupWallet =
      Size(Get.width * 2 / 3, 18.0);

  ///26.0 pixel
  static const spaceBetweenTwoIndicatorSplash = 26.0;

  ///Size(64.0, 6.0)
  static const sizeIcDragAddAccount = Size(64.0, 6.0);
}

extension ScaleSizeScreen on double {
  double get hs => this * Get.height / AppSizes.sizeDesign.height;
  double get ws => this * Get.width / AppSizes.sizeDesign.width;
}
