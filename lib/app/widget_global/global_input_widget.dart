import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/asset_values.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class GlobalInputSecurityWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function validator;
  final Function onTap;
  final bool security;
  final String hintText;
  final Function onTapIcEye;
  final Color? color;

  const GlobalInputSecurityWidget({
    Key? key,
    required this.controller,
    required this.validator,
    required this.onTap,
    required this.security,
    required this.hintText,
    required this.onTapIcEye,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          controller: controller,
          validator: (text) => validator(text),
          keyboardType: TextInputType.text,
          onTap: () {
            onTap();
          },
          style: AppTextTheme.bodyText1.copyWith(color: Colors.black),
          obscureText: security,
          // obscuringCharacter: '*',
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            errorMaxLines: 3,
            filled: true,
            fillColor: color ?? AppColorTheme.focus,
            isCollapsed: true,
            contentPadding: EdgeInsets.only(
              top: 20.0,
              bottom: 20.0,
              left: 20.0,
              right: 48.0,
            ),
            hintStyle:
                AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black50),
            errorStyle:
                AppTextTheme.bodyText2.copyWith(color: AppColorTheme.error),
            hintText: hintText,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
            ),
          ),
        ),
        Positioned(
          right: 0.0,
          top: 0.0,
          height: 61.0,
          child: IconButton(
            splashRadius: AppSizes.borderRadiusSmall,
            onPressed: () {
              onTapIcEye();
            },
            icon: SvgPicture.asset(security
                ? AppAssets.globalIcEyeHidden
                : AppAssets.globalIcEyeVisible),
          ),
        ),
      ],
    );
  }
}

class GlobalInputWidget extends StatelessWidget {
  final Function? onChange;
  final String hintText;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final Color? color;
  final Function? validator;
  final String? errorText;
  final int? maxLength;
  final Function? onTap;

  const GlobalInputWidget({
    Key? key,
    this.onChange,
    this.color,
    required this.hintText,
    this.textInputType,
    this.controller,
    this.validator,
    this.errorText,
    this.maxLength,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType ?? TextInputType.name,
      controller: controller,
      onChanged: (value) {
        if (onChange != null) {
          onChange!(value);
        }
        ;
      },
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      maxLength: maxLength,
      style: AppTextTheme.bodyText1
          .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        filled: true,
        fillColor: color ?? AppColorTheme.card,
        isCollapsed: true,
        contentPadding: EdgeInsets.only(
          top: 20.0,
          bottom: 20.0,
          left: 20.0,
          right: 48.0,
        ),
        hintStyle:
            AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black50),
        hintText: hintText,
        errorText: errorText,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
        ),
      ),
    );
  }
}

class GlobalInputSearchWidget extends StatelessWidget {
  final Function? onChange;
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController? controller;
  final Color? color;
  final bool haveBorder;

  const GlobalInputSearchWidget({
    Key? key,
    this.onChange,
    this.color,
    required this.hintText,
    required this.textInputType,
    this.controller,
    this.haveBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          keyboardType: textInputType,
          controller: controller,
          onChanged: (value) {
            if (onChange != null) {
              onChange!(value);
            }
            ;
          },
          style: AppTextTheme.bodyText1
              .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: color ?? AppColorTheme.focus,
            isCollapsed: true,
            contentPadding: EdgeInsets.only(
              top: 13.5,
              bottom: 13.5,
              left: 20.0,
              right: 48.0,
            ),
            hintStyle:
                AppTextTheme.bodyText1.copyWith(color: Get.theme.hintColor),
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color:
                      haveBorder ? AppColorTheme.black25 : Colors.transparent,
                  width: 0.5),
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: haveBorder
                      ? AppColorTheme.textAccent80
                      : Colors.transparent,
                  width: 0.5),
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
            ),
          ),
        ),
        Positioned(
          right: 0.0,
          top: 0.0,
          height: 48.0,
          child: IconButton(
            splashRadius: AppSizes.borderRadiusSmall,
            onPressed: () {},
            icon: Icon(
              Icons.search_outlined,
              color: AppColorTheme.black60,
            ),
          ),
        ),
      ],
    );
  }
}
