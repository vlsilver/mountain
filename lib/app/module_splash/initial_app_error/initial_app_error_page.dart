import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/asset_values.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'initial_app_error_controller.dart';

class InitialAppErrorPage extends GetView<InitialAppErrorController> {
  const InitialAppErrorPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorTheme.accent,
      appBar: AppBar(
        toolbarHeight: 0.0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppAssets.globalLogo1, height: 64.0),
          SizedBox(height: AppSizes.spaceVeryLarge),
          GlobalButtonWidget(
            name: controller.btnStr,
            type: ButtonType.ERROR,
            onTap: controller.handleButtonRestartOnTap,
          )
        ],
      ),
    );
  }
}
