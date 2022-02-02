import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/asset_values.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GlobalEmptyListWidget extends StatelessWidget {
  const GlobalEmptyListWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.globalEmptyBg,
            width: Get.width / 2,
          ),
          SizedBox(height: AppSizes.spaceNormal),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextTheme.headline2.copyWith(color: AppColorTheme.accent),
          )
        ],
      ),
    );
  }
}
