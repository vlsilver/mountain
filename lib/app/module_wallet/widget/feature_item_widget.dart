import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class FeatureItemWidget extends StatelessWidget {
  const FeatureItemWidget({
    Key? key,
    required this.color,
    required this.icon,
    required this.name,
    this.svg = '',
  }) : super(key: key);

  final Color color;
  final IconData? icon;
  final String name;
  final String svg;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (Get.width / 2) * .55,
      width: (Get.width / 2) * .55,
      padding: EdgeInsets.all(AppSizes.spaceVerySmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
        color: AppColorTheme.focus,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          svg.isEmpty
              ? Container(
                  height: 40.0,
                  width: 40.0,
                  alignment: Alignment.center,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                  child: Center(
                      child: Icon(
                    icon,
                    color: AppColorTheme.focus,
                  )),
                )
              : Container(
                  height: 40.0,
                  width: 40.0,
                  child: SvgPicture.asset(svg),
                ),
          SizedBox(height: AppSizes.spaceSmall),
          Flexible(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTextTheme.bodyText1
                  .copyWith(color: AppColorTheme.text, fontSize: 13),
            ),
          )
        ],
      ),
    );
  }
}
