import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'splash_controller.dart';
import 'widget/bg_widget.dart';
import 'widget/indicator_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.0,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SplashBackgroundWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  children: controller.listIntroWidget,
                ),
              ),
              SizedBox(height: AppSizes.spaceVeryLarge),
              Center(
                child: SplashIndicatorWidget(),
              ),
              SizedBox(height: AppSizes.spaceNormal),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
                child: GlobalButtonWidget(
                  onTap: () {
                    controller.handleButtonOnTap();
                  },
                  name: 'splash_btn_start'.tr,
                  type: ButtonType.NORMAL,
                ),
              ),
              SizedBox(height: AppSizes.spaceVeryLarge),
            ],
          ),
        ));
  }
}
