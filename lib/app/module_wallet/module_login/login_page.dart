import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:base_source/app/widget_global/global_layout_builder_widget.dart';
import 'package:base_source/app/widget_global/global_logo_widget.dart';
import 'package:base_source/app/widget_global/global_switch_touchId_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'login_controller.dart';
import 'widget/bg_widget.dart';
import 'widget/form_input_widget.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginBackgroundWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 0.0,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: InkWell(
          focusNode: controller.focusNode,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            controller.handleScreenOnTap();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: AppSizes.spaceVeryLarge),
              Expanded(
                child: GlobalLayoutBuilderWidget(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceVeryLarge,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GlobalLogoWidget(
                          height: 86.0,
                          type: 1,
                        ),
                        SizedBox(height: AppSizes.spaceNormal),
                        Text(
                          'titleLogin'.tr,
                          textAlign: TextAlign.center,
                          style: AppTextTheme.headline2
                              .copyWith(color: AppColorTheme.focus),
                        ),
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: AppSizes.spaceMax,
                                maxHeight: AppSizes.spaceMax),
                          ),
                        ),
                        LoginFormInputWidget(),
                        SizedBox(height: AppSizes.spaceSmall),
                        GetBuilder<LoginController>(
                          id: EnumUpdateLogin.SWITCH_TOUCH_ID,
                          builder: (_) {
                            return GlobalSwitchTouchIdWidget(
                              onChange: _.handleSwitchTouchIdOnChange,
                              value: _.biometricState,
                              color: AppColorTheme.focus,
                              isBold: true,
                            );
                          },
                        ),
                        SizedBox(height: AppSizes.spaceLarge),
                        _GroupButtonAndBiometricWidget(),
                        SizedBox(
                          height: AppSizes.spaceNormal,
                        ),
                        Text(
                          'descResetStr'.tr,
                          style: AppTextTheme.bodyText2
                              .copyWith(color: AppColorTheme.focus),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: AppSizes.spaceVerySmall,
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.handleResetTextOnTap();
                          },
                          onLongPress: () {
                            controller.handleResetTextOnLongPress();
                          },
                          child: Text(
                            'resetStr'.tr,
                            style: AppTextTheme.bodyText1.copyWith(
                                color: AppColorTheme.highlight,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.spaceVeryLarge,
                        )
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupButtonAndBiometricWidget extends GetView<LoginController> {
  const _GroupButtonAndBiometricWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GetBuilder<LoginController>(
              id: EnumUpdateLogin.BUTTON,
              builder: (_) => GlobalButtonWidget(
                  borderRadius: AppSizes.borderRadiusMedium,
                  name: 'btnLogin'.tr,
                  type: controller.isActiveButton
                      ? ButtonType.FOCUS
                      : ButtonType.DISABLE,
                  onTap: () {
                    controller.handleButtonLoginOnTap();
                    // controller.handleButtonLoginOnTap();
                  })),
        ),
        controller.authenService.biometricUnknow ||
                !controller.acceptedBiometric
            ? SizedBox()
            : SizedBox(
                height: AppSizes.sizeButtonWidget.height,
                child: IconButton(
                    iconSize: AppSizes.sizeButtonWidget.height,
                    padding: EdgeInsets.only(left: AppSizes.spaceSmall),
                    onPressed: () {
                      controller.handleBiometricIconOnTap();
                    },
                    icon: SvgPicture.asset(
                      controller.authenService.biometricTouchID
                          ? controller.icTouchId
                          : controller.icFaceId,
                      height: AppSizes.spaceMaxMedium,
                    )),
              )
      ],
    );
  }
}
