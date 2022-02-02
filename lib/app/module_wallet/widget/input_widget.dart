import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputWidget extends StatelessWidget {
  const InputWidget({
    Key? key,
    required this.controller,
    required this.onTap,
    required this.hintText,
    this.right,
    this.textStyle,
  }) : super(key: key);

  final TextEditingController controller;
  final Function onTap;
  final String hintText;
  final double? right;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      onTap: () {
        onTap();
      },
      style: textStyle ??
          AppTextTheme.bodyText1
              .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
      textAlignVertical: TextAlignVertical.center,
      maxLines: null,
      decoration: InputDecoration(
        errorMaxLines: 2,
        filled: true,
        fillColor: AppColorTheme.card,
        isCollapsed: true,
        contentPadding: EdgeInsets.only(
          top: 21.5,
          bottom: 21.5,
          left: 16.0,
          right: right ?? 48.0,
        ),
        hintStyle: AppTextTheme.bodyText1.copyWith(color: Get.theme.hintColor),
        errorStyle: AppTextTheme.bodyText2.copyWith(color: AppColorTheme.error),
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
        ),
      ),
    );
  }
}
