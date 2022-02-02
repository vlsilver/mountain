import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalAppbarWiget extends StatelessWidget {
  const GlobalAppbarWiget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.spaceMax,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: AppSizes.spaceSmall),
          IconButton(
            onPressed: () {
              onTap();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: AppColorTheme.textAccent,
            ),
          ),
          Text(
            'global_back'.tr,
            style: AppTextTheme.bodyText1
                .copyWith(color: AppColorTheme.textAccent),
          ),
        ],
      ),
    );
  }
}
