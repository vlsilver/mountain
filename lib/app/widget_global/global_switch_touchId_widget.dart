import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/data/services/authen_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalSwitchTouchIdWidget extends StatelessWidget {
  const GlobalSwitchTouchIdWidget({
    Key? key,
    required this.onChange,
    required this.value,
    this.color = AppColorTheme.textAccent,
    this.isBold = false,
    this.style,
  }) : super(key: key);

  final bool value;
  final Function onChange;
  final Color color;
  final bool isBold;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final _authenService = Get.find<AuthenService>();
    return _authenService.biometricUnknow
        ? Container()
        : Row(
            children: [
              Expanded(
                child: Text(
                  _authenService.biometricTouchID
                      ? 'create_password_touch_id_desc'.tr
                      : 'global_faceId'.tr,
                  style: style ??
                      AppTextTheme.bodyText1.copyWith(
                          color: color,
                          fontWeight: isBold ? FontWeight.bold : null),
                ),
              ),
              CupertinoSwitch(
                  activeColor: AppColorTheme.toggleableActiveColor,
                  trackColor: Colors.black.withOpacity(0.3),
                  value: value,
                  onChanged: (_) {
                    onChange();
                  }),
            ],
          );
  }
}
