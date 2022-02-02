import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/asset_values.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'custom_bottombar/animated_bottom_navigation_bar.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColorTheme.accent,
      extendBody: true,
      body: PageView.builder(
          itemCount: controller.pages.length,
          controller: controller.pageController,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return controller.pages[index];
          }),
      floatingActionButton: const _FloatButtonFunctionWidget(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: _bottomBarWidget(),
    );
  }

  Widget _bottomBarWidget() {
    return const _BottomBarCustomWidget();
  }
}

class _BottomBarCustomWidget extends GetView<HomeController> {
  const _BottomBarCustomWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titles = <String>[
      'global_wallet'.tr,
      'global_markets'.tr,
      'global_account'.tr,
      'global_setting'.tr,
    ];
    return GetBuilder<HomeController>(
      id: EnumUpdateHome.BOTTOM_BAR,
      builder: (_) {
        return AnimatedBottomNavigationBar.builder(
          itemCount: _.bottomBarAssetActive.length,
          tabBuilder: (int index, bool isActive) {
            final active = _.isActive(index);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  _.bottomBarAssetActive[index],
                  color: active ? null : AppColorTheme.disable,
                ),
                Text(
                  titles[index],
                  style: AppTextTheme.bodyText2.copyWith(
                    color: active
                        ? AppColorTheme.iconActive
                        : AppColorTheme.disable,
                  ),
                )
              ],
            );
          },
          elevation: 16.0,
          backgroundColor: AppColorTheme.bottombar,
          activeIndex: _.page(),
          splashSpeedInMilliseconds: 300,
          notchSmoothness: NotchSmoothness.softEdge,
          notchMargin: 4.0,
          gapLocation: GapLocation.center,
          leftCornerRadius: 32.0,
          rightCornerRadius: 32.0,
          onTap: (index) {
            _.handleItemBottomBarOnTap(index: index);
          },
        );
      },
    );
  }
}

class _FloatButtonFunctionWidget extends GetView<HomeController> {
  const _FloatButtonFunctionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64.0,
      width: 64.0,
      child: FloatingActionButton(
        elevation: 0.0,
        splashColor: Colors.transparent,
        backgroundColor: AppColorTheme.white80,
        onPressed: () {
          controller.handleItemBottomBarOnTap(index: 4);
        },
        child: Container(
          height: 52.0,
          width: 52.0,
          padding: const EdgeInsets.all(AppSizes.spaceNormal),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF5FB2FF),
                  Color(0xFF3BA0FF),
                ],
                stops: [
                  0.0,
                  1.0
                ]),
          ),
          child: Center(
            child: SvgPicture.asset(
              AppAssets.icBottomBarFunction,
              color: AppColorTheme.white,
              height: 28.0,
              width: 28.0,
            ),
          ),
        ),
      ),
    );
  }
}
