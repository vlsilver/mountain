import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashIntroWidget extends StatelessWidget {
  const SplashIntroWidget({
    required this.headline,
    required this.body,
    required this.asset,
    Key? key,
  }) : super(key: key);
  final String headline;
  final String body;
  final String asset;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(asset),
        SizedBox(height: AppSizes.spaceLarge),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSizes.spaceVeryLarge),
          child: Text(
            headline,
            textAlign: TextAlign.center,
            style: AppTextTheme.headline1.copyWith(fontSize: 20.0),
          ),
        ),
        SizedBox(height: AppSizes.spaceLarge),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
          child: Text(
            body,
            textAlign: TextAlign.center,
            style: AppTextTheme.bodyText1,
          ),
        )
      ],
    );
  }
}
