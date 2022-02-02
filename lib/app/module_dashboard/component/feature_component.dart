import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FeatureComponent extends StatelessWidget {
  final Function onFunction;
  final String imagePath;
  final String text;

  const FeatureComponent(
      {required this.onFunction,
      required this.imagePath,
      required this.text,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = (Get.width - 48.0) / 2;
    return CupertinoButton(
      onPressed: () {
        onFunction();
      },
      padding: EdgeInsets.zero,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusNormal),
            border: Border.all(color: AppColorTheme.textAction, width: 0.25)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              imagePath,
              width: 56.0,
              height: 56.0,
            ),
            SizedBox(height: AppSizes.spaceSmall),
            Text(
              text,
              style:
                  AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black60),
            )
          ],
        ),
      ),
    );
  }
}
