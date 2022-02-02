import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

class GlobalEmptyWidget extends StatelessWidget {
  const GlobalEmptyWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: AppTextTheme.bodyText1.copyWith(
          color: AppColorTheme.accent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
