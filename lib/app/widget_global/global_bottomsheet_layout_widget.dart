import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalBottomSheetLayoutWidget extends StatelessWidget {
  const GlobalBottomSheetLayoutWidget({
    Key? key,
    this.height,
    this.color,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? Get.height * 0.85,
      child: Material(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.borderRadiusVeryLarge),
        ),
        color: color ?? AppColorTheme.white,
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            SizedBox(height: AppSizes.spaceSmall),
            Container(
              height: AppSizes.sizeIcDragAddAccount.height,
              width: AppSizes.sizeIcDragAddAccount.width,
              decoration: BoxDecoration(
                color: AppColorTheme.disable,
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusVeryLarge),
              ),
            ),
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
