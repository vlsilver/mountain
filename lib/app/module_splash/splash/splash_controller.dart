import 'package:base_source/app/core/values/asset_values.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widget/intro_widget.dart';

class SplashController extends GetxController {
  final PageController pageController = PageController();

  final RxDouble leftSpaceOfIndicatorActive = 0.0.obs;

  List<SplashIntroWidget> listIntroWidget = [
    SplashIntroWidget(
        headline: 'splash_headline_1'.tr,
        body: 'splash_body_1'.tr,
        asset: AppAssets.splash1),
    SplashIntroWidget(
        headline: 'splash_headline_2'.tr,
        body: 'splash_body_2'.tr,
        asset: AppAssets.splash2),
    SplashIntroWidget(
        headline: 'splash_headline_3'.tr,
        body: 'splash_body_3'.tr,
        asset: AppAssets.splash3),
  ];

  @override
  void onReady() async {
    await Future.delayed(Duration(milliseconds: 200));
    pageController.addListener(() {
      handlePageViewChangeScrollChange();
    });
    super.onReady();
  }

  @override
  void onClose() {
    pageController.removeListener(() {});
    super.onClose();
  }

  void handlePageViewChangeScrollChange() {
    leftSpaceOfIndicatorActive.value =
        AppSizes.spaceBetweenTwoIndicatorSplash * pageController.page!;
  }

  void handleButtonOnTap() {
    Get.offAllNamed(AppRoutes.CHOICE_SETUP_WALLET);
  }
}
